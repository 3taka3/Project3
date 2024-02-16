provider "aws" {
  region                      = var.region
}

# PARAMETRAGE RESEAU VPC -
  # 1. Création du VPC
  resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_vpc
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MyVPC1"
  }
}

# 2. Création routeur et gateway associéé
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id 
  tags = {
    Name = "MyGW1"
  }

depends_on = [aws_vpc.my_vpc]
}

resource "aws_route_table" "my_route" {
  vpc_id = aws_vpc.my_vpc.id 
  route {
    cidr_block = var.cidr_route
    gateway_id = aws_internet_gateway.my_igw.id 
  }
  tags = {
    Name = "MyRouteur1"
  }

depends_on = [aws_internet_gateway.my_igw]
}

# 3. Création des sous-réseaux Clark et Mongo 
resource "aws_subnet" "my_subnet_spark" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.cidr_subnet_spark
  availability_zone = var.availability_zone

  tags = {
    Name = "MySubnet_Spark1"
  }

depends_on = [aws_route_table.my_route]
}

resource "aws_subnet" "my_subnet_mongo1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.cidr_subnet_mongo1
  availability_zone = var.availability_zone
  tags = {
    Name = "MySubnet_Mongo1"
  }
}

resource "aws_subnet" "my_subnet_mongo2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.cidr_subnet_mongo2
  availability_zone = var.availability_zone
  tags = {
    Name = "MySubnet_Mongo2"
  }
}


# 4. Association de la table de routage aux sous-réseaux
resource "aws_route_table_association" "route_my_subnet_spark" {
  subnet_id      = aws_subnet.my_subnet_spark.id
  route_table_id = aws_route_table.my_route.id
}
resource "aws_route_table_association" "my_route_my_subnet_mongo1" {
  subnet_id      = aws_subnet.my_subnet_mongo1.id
  route_table_id = aws_route_table.my_route.id
}
resource "aws_route_table_association" "my_route_my_subnet_mongo2" {
  subnet_id      = aws_subnet.my_subnet_mongo2.id
  route_table_id = aws_route_table.my_route.id
}


# 5. Security groups
resource "aws_security_group" "sparkm_security_group" {
  name        = "sg_master"
  description = "spark_security_group_master"
  vpc_id     = aws_vpc.my_vpc.id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port_sparks
    protocol    = var.ingress_protocol
    cidr_blocks = var.cidr_sg_spark
  }

  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.cidr_sg_spark
  }
}

resource "aws_security_group" "sparkc_security_group" {
  name        = "sg_core"
  description = "spark_security_group_core"
  vpc_id     = aws_vpc.my_vpc.id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port_sparks
    protocol    = var.ingress_protocol
    cidr_blocks = var.cidr_sg_spark
  }

  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.cidr_sg_spark
  }
}

resource "aws_security_group" "mongo_security_group" {
  name        = "sg_core"
  description = "mongo_security_group"
  vpc_id     = aws_vpc.my_vpc.id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port_mongo
    protocol    = var.ingress_protocol
    cidr_blocks = var.cidr_sg_mongo
  }

  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = var.cidr_sg_mongo
  }
}

#Clé SSH
resource "aws_key_pair" "key_ec2" {
  key_name   = var.key_name 
  public_key = file(var.public_key_path)
}


# PARAMETRAGE CLUSTERS -

#Spark Cluster
resource "aws_emr_cluster" "spark_cluster" {
  name          = "mon_cluster_spark"
  release_label = var.version_emr 
  applications  = ["Hadoop","Spark"]
  service_role  = var.service_role

  termination_protection            = false
  keep_job_flow_alive_when_no_steps = false

  # Configuration du réseau du cluster
  ec2_attributes {
    subnet_id                         = aws_subnet.my_subnet_spark.id
    emr_managed_master_security_group = aws_security_group.sparkm_security_group.id
    emr_managed_slave_security_group  = aws_security_group.sparkc_security_group.id
    key_name = aws_key_pair.key_ec2.key_name 
    instance_profile                  = var.instance_profile
  }

  master_instance_group {
    instance_type = var.master_instance_type
  }

  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.sparkcore_instance_count
    ebs_config {
      size                 = var.ebs_size
      type                 = var.ebs_type
      volumes_per_instance = var.volume_per_instances
    }
  }
depends_on = [aws_security_group.sparkc_security_group]
}


# MongoDB - Cluster

#Instance
resource "aws_docdb_cluster_instance" "mongodb_instance" {
  count                  = var.mongo_instance_count
  identifier             = "mongodb-instance-${count.index}"
  instance_class         = var.instance_class
  cluster_identifier     = aws_docdb_cluster.mongodb_cluster.id
  availability_zone      = var.availability_zone
}

#Subnet groupe
resource "aws_docdb_subnet_group" "mongodb_subnet_group" {
  subnet_ids = [ 
    aws_subnet.my_subnet_mongo1.id,
    aws_subnet.my_subnet_mongo2.id,
  ]
}

#Cluster
resource "aws_docdb_cluster" "mongodb_cluster" {
  cluster_identifier            = "mongodb-cluster"
  engine                        = "docdb"
  master_username               = var.master_username
  master_password               = var.master_password 
  backup_retention_period       = var.backup_retention_period
  preferred_backup_window       = var.backup_window
  skip_final_snapshot           = true
  db_subnet_group_name          = aws_docdb_subnet_group.mongodb_subnet_group.name
  vpc_security_group_ids        = [aws_security_group.mongo_security_group.id]
  storage_encrypted             = true
}
