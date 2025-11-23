locals {
  do_token = getenv("DIGITALOCEAN_TOKEN")
}

remote_state {
  backend = "s3"

  config = {
    endpoint                    = "https://nyc3.digitaloceanspaces.com"
    bucket                      = "REPLACE_ME"
    key                         = "global/terraform.tfstate"
    region                      = "us-east-1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    force_path_style            = true
    encrypt                     = true
  }
}

inputs = {
  do_token = local.do_token
}
