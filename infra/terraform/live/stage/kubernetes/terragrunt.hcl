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
  # do_token = run_cmd("doppler", "secrets", "get",
  #   "--project", "my-devops-project",
  #   "--config", "stg",
  #   "DIGITALOCEAN_TOKEN",
  #   "--plain"
  # )
  environment = "stg"
  vpc_id      = dependency.network.outputs.vpc_id
}