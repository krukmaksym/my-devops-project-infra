output "vpc_id" {
  description = "DigitalOcean provisioned VPC id"
  value       = digitalocean_vpc.vpc.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = digitalocean_vpc.vpc.name
}

output "vpc_region" {
  description = "Region where the VPC is deployed"
  value       = digitalocean_vpc.vpc.region
}