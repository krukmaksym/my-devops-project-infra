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
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.69.0"
    }
  }
  required_version = "1.14.0"
}

provider "digitalocean" {
  token = var.do_token
}
EOF
}