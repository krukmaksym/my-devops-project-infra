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
}

inputs = {
  environment = "stg"
  vpc_id      = dependency.network.outputs.vpc_id
}