locals {
  env = basename(dirname(get_terragrunt_dir()))

  argocd = {
    dev = {
      argocd_chart_version = "7.8.13"
    }

    stage = {
      argocd_chart_version = "7.8.13"
    }

    prod = {
      argocd_chart_version = "7.8.13"
    }
  }
}

inputs = local.argocd[local.env]
