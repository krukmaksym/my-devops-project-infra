// tflint-ignore: terraform_unused_declarations
variable "do_token" {
  type      = string
  sensitive = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC to provision"
  type        = string
  default     = "10.10.10.0/24"
}

variable "environment" {
  description = "DigitalOcean env to provision"
  type        = string
}