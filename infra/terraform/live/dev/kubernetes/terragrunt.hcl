include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/kubernetes.hcl"
}

terraform {
  source = "../../../modules/kubernetes"
}

dependency "network" {
  config_path = "../network"
  mock_outputs = {
    vpc_id = "mock-vpc-id"
  }
}

inputs = {
  environment = "dev"
  vpc_id      = dependency.network.outputs.vpc_id
}