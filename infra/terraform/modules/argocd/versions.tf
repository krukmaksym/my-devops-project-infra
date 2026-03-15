terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
    # Not used by this module, but root.hcl generates a digitalocean
    # provider block for all modules — the source mapping is required
    # so Terraform resolves digitalocean/digitalocean, not hashicorp/digitalocean.
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }
}
