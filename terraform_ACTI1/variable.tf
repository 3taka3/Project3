#PROVIDER
variable "region" {
  default = "us-east-1"
}

#VPC
variable "cidr_vpc" {
  default = "10.0.0.0/24"
}
variable "cidr_route" {
  default = "0.0.0.0/0"
}


#SUBNET
variable "availability_zone" {
  default = "us-east-1a"
}

variable "availability_zone2" {
  default = "us-east-1b"
}

variable "cidr_subnet_spark" {
  default = "10.0.0.0/26"
  sensitive = true
}

variable "cidr_subnet_mongo1" {
  default = "10.0.0.64/26"
  sensitive = true
}

variable "cidr_subnet_mongo2" {
  default = "10.0.0.128/26"
  sensitive = true
}


#SECURITY GROUPS -
variable "cidr_sg_spark" {
  default = ["0.0.0.0/0"]
  sensitive = true
}

variable "cidr_sg_mongo" {
  default = ["0.0.0.0/0"]
  sensitive = true
}

#ingress
variable "ingress_protocol" {
  default = "tcp"
}

variable "ingress_from_port" {
  default = 0
}

variable "ingress_to_port_sparks" {
  default = 22
  sensitive = true

}

variable "ingress_to_port_mongo" {
  default = 27017
  sensitive = true

}

#egress
variable "egress_protocol" {
  default = "-1"
}

variable "egress_from_port" {
  default = 0
}

variable "egress_to_port" {
  default = 0
}


#SSH KEY
variable "key_name" {
  default = "key_ec2"
  sensitive = true
}
variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
  sensitive = true
}

#CLUSTER SPARK - 
variable "version_emr" {
  default = "emr-6.4.0"
}
variable "service_role" {
  default = "EMR_EC2_Role"
}

#Instances 
variable "instance_profile" {
  default = "EC2_4EMR"
}

#master 
variable "master_instance_type" {
  default = "m4.large"
}

#core 
variable "core_instance_type" {
  default = "c4.large"
}
variable "sparkcore_instance_count" {
  default = 1
}
variable "ebs_size" {
  default = "40"
}
variable "ebs_type" {
  default = "gp2"
}
variable "volume_per_instances" {
  default = 1
}

#MONGO - Cluster
variable "mongo_instance_count" {
  default = 2
}
variable "instance_class" {
  default = "db.r5.large"
}

#login
variable "master_username" {
  default = "adminuser"
  sensitive = true
}
variable "master_password" {
  default = "adminpassw4rd!"
  sensitive = true
}

#Rules 
variable "backup_retention_period" {
  default = 5
}
variable "backup_window" {
  default = "05:00-07:00"
}
