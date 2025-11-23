terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.69.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}


resource "digitalocean_vpc" "vpc" {
  name     = "${var.environment}-vpc"
  region   = var.region
  ip_range = var.vpc_cidr
}
