module "gke" {
  source = "terraform-google-modules/kubernetes-engine/google"

  cluster_name = "your-cluster-name"
  project      = "your-project-id"
  region       = "your-region"

  node_pools = [
    {
      name            = "default-pool"
      machine_type    = "n1-standard-2"
      initial_node_count = 1
    },
  ]
}