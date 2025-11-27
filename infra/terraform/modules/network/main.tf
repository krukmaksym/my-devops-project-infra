resource "digitalocean_vpc" "vpc" {
  name     = "${var.environment}-vpc"
  region   = var.region
  ip_range = var.vpc_cidr

  lifecycle {
    prevent_destroy = true
  }
}
