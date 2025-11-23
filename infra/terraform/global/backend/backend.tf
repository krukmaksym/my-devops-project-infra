terraform {
  backend "s3" {
    endpoint                    = var.s3_endpoint
    bucket                      = var.s3_bucket
    key                         = "global/terraform.tfstate"
    region                      = "us-east-1"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    force_path_style            = true

    encrypt = true
  }
}

variable "s3_endpoint" {}
variable "s3_bucket" {}
