include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/network.hcl"
}

terraform {
  source = "../../../modules/network"
}

# inputs = {
#   do_token = run_cmd("doppler", "secrets", "get",
#     "--project", "my-devops-project",
#     "--config", "prd",
#     "DIGITALOCEAN_TOKEN",
#     "--plain"
#   )
# }