# Inherit remote_state config from root terragrunt.hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//"
}

locals {
  environment = "prod"

  # Global settings for this environment
  network_cidr = "10.0.0.0/16"
  ssh_key_name = "devops-key"
}

dependencies {
  paths = [
    "../../global/network",
    "../../global/iam"
  ]
}

inputs = {
  environment     = local.environment
  network_cidr    = local.network_cidr
  ssh_key_name    = local.ssh_key_name

  # Kubernetes Cluster settings
  master_count    = 3
  worker_count    = 3
  instance_type   = "cx22"

  # Module-specific config (we will add later)
  # e.g., lb_enabled      = true
  #       monitoring      = true
}
