locals {
  project = "my-devops-project"
}

remote_state {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "my-devops-project"

    workspaces = {
      name = "${local.project}-${path_relative_to_include()}"
    }
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "digitalocean" {}
EOF
}