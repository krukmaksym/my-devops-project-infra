include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/monitoring"
}

dependency "kubernetes" {
  config_path = "../kubernetes"
  mock_outputs = {
    cluster_id = "mock-id"
  }
}

locals {
  env = "stage"
}

inputs = {
}

generate "provider_k8s" {
  path      = "provider_k8s.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "digitalocean_kubernetes_cluster" "k8s" {
  name = "${local.env}-cluster"
}

provider "kubernetes" {
  host                   = data.digitalocean_kubernetes_cluster.k8s.endpoint
  token                  = data.digitalocean_kubernetes_cluster.k8s.kube_config[0].token
  cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.digitalocean_kubernetes_cluster.k8s.endpoint
    token                  = data.digitalocean_kubernetes_cluster.k8s.kube_config[0].token
    cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate)
  }
}
EOF
}
