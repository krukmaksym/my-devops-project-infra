locals {
  env = basename(dirname(get_terragrunt_dir()))

  common_tags = {
    project     = "my-devops-project"
    environment = local.env
    component   = "network"
  }

  network = {
    dev = {
      region   = "fra1"
      vpc_cidr = "10.10.10.0/24"
    }

    stage = {
      region   = "fra1"
      vpc_cidr = "10.20.0.0/24"
    }

    prod = {
      region   = "fra1"
      vpc_cidr = "10.30.0.0/24"
    }
  }
}

inputs = merge(
  local.network[local.env],
  {
    environment = local.env
    tags        = local.common_tags
  }
)
