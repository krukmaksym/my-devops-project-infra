locals {
  project = "my-devops-project"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "my-devops-project"

    workspaces {
      name = "${local.project}-${replace(path_relative_to_include(), "/", "-")}"
    }
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "digitalocean" {}
EOF
}