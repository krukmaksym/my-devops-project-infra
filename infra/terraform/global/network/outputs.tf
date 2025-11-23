output "vpc_id" {
  description = "DigitalOcean provisioned VPC id"
  value       = digitalocean_vpc.vpc.id
}