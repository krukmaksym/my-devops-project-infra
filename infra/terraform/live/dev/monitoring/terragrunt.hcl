include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/monitoring"
}

dependency "kubernetes" {
  config_path = "../kubernetes"
}

locals {
  env = "dev"
}


generate "provider_k8s" {
  path      = "provider_k8s.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  host                   = "${dependency.kubernetes.outputs.endpoint}"
  token                  = "${dependency.kubernetes.outputs.cluster_token}"
  cluster_ca_certificate = base64decode("${dependency.kubernetes.outputs.cluster_ca_certificate}")
}

provider "helm" {
  kubernetes {
    host                   = "${dependency.kubernetes.outputs.endpoint}"
    token                  = "${dependency.kubernetes.outputs.cluster_token}"
    cluster_ca_certificate = base64decode("${dependency.kubernetes.outputs.cluster_ca_certificate}")
  }
}
EOF
}
