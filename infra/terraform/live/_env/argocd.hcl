locals {
  env = basename(dirname(get_terragrunt_dir()))

  argocd = {
    dev = {
      argocd_chart_version = "7.8.13"
      environment          = "dev"
      server_insecure      = true
      admin_enabled        = true
      replace_on_failure   = true
      lb_source_ranges     = ["85.114.192.213/32"]
    }

    stage = {
      argocd_chart_version = "7.8.13"
      environment          = "stage"
      server_insecure      = false
      admin_enabled        = false
      replace_on_failure   = false
      lb_source_ranges     = ["PLACEHOLDER/32"]
    }

    prod = {
      argocd_chart_version = "7.8.13"
      environment          = "prod"
      server_insecure      = false
      admin_enabled        = false
      replace_on_failure   = false
      lb_source_ranges     = ["PLACEHOLDER/32"]
    }
  }
}

inputs = local.argocd[local.env]
