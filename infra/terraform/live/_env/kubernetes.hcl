locals {
  env = basename(dirname(get_terragrunt_dir()))

  kubernetes = {
    dev = {
      region               = "fra1"
      k8s_version          = "1.35.1-do.0"
      cluster_name         = "dev-k8s"
      node_count           = 2
      node_size            = "s-2vcpu-2gb"
      auto_scale           = true
      min_nodes            = 2
      max_nodes            = 4
      monitoring_node_size = "s-2vcpu-4gb"
    }

    stage = {
      region       = "fra1"
      k8s_version  = "1.35.1-do.0"
      cluster_name = "stage-k8s"
      node_count   = 3
      node_size    = "s-2vcpu-4gb"
      auto_scale   = true
      min_nodes    = 3
      max_nodes    = 6
    }

    prod = {
      region       = "fra1"
      k8s_version  = "1.35.1-do.0"
      cluster_name = "prod-k8s"
      node_count   = 3
      node_size    = "s-2vcpu-8gb"
      auto_scale   = true
      min_nodes    = 3
      max_nodes    = 10
    }
  }

  common_tags = [
    "project:my-devops-project",
    "component:kubernetes",
    "environment:${local.env}"
  ]
}

generate "provider_do" {
  path      = "provider_do.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "digitalocean" {
  token = var.do_token
}
EOF
}

inputs = merge(
  local.kubernetes[local.env],
  {
    tags = local.common_tags
  }
)
