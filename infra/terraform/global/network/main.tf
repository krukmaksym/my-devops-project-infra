terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.69.0"
    }
  }
  required_version = "1.5.7"
}

provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_vpc" "vpc" {
  name     = "${var.environment}-vpc"
  region   = var.region
  ip_range = var.vpc_cidr

  lifecycle {
    prevent_destroy = true
  }
}
