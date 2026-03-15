include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/monitoring.hcl"
}

terraform {
  source = "../../../modules/monitoring"
}

dependency "kubernetes" {
  config_path = "../kubernetes"

  # Skip fetching real outputs - the prod kubernetes cluster doesn't exist yet.
  # This forces Terragrunt to use mock_outputs for all commands.
  # TODO: Remove this once the prod kubernetes cluster is deployed.
  skip_outputs = true

  # Mock outputs allow us to validate and plan even if the Kubernetes cluster
  # hasn't been instantiated yet (e.g. during CI checks for other envs).
  mock_outputs = {
    cluster_id             = "mock-id"
    endpoint               = "https://mock-endpoint"
    cluster_token          = "mock-token"
    cluster_ca_certificate = "bW9jay1jZXJ0" # base64 "mock-cert"
  }

  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

locals {
  env = "prod"
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
  kubernetes = {
    host                   = "${dependency.kubernetes.outputs.endpoint}"
    token                  = "${dependency.kubernetes.outputs.cluster_token}"
    cluster_ca_certificate = base64decode("${dependency.kubernetes.outputs.cluster_ca_certificate}")
  }
}
EOF
}
