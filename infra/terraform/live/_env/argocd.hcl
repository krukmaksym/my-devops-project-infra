locals {
  env = basename(dirname(get_terragrunt_dir()))

  argocd = {
    dev = {
      argocd_chart_version = "7.8.13"
      # Restrict LB access to specific CIDRs. Set your office/VPN IP here.
      # Example: ["203.0.113.10/32"]
      lb_source_ranges = []
    }

    stage = {
      argocd_chart_version = "7.8.13"
      lb_source_ranges     = []
    }

    prod = {
      argocd_chart_version = "7.8.13"
      lb_source_ranges     = []
    }
  }
}

inputs = local.argocd[local.env]
