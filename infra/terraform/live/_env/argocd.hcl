locals {
  env = basename(dirname(get_terragrunt_dir()))

  argocd = {
    dev = {
      argocd_chart_version = "7.8.13"
      environment          = "dev"
      server_insecure      = true
      replace_on_failure   = true
      lb_source_ranges     = ["0.0.0.0/0"]

      # GitHub OAuth SSO — fill in after creating the OAuth App:
      # 1. Deploy ArgoCD, note the LoadBalancer IP
      # 2. Create GitHub OAuth App with callback: http://<LB-IP>/api/dex/callback
      # 3. Set the values below and re-apply
      admin_enabled              = true # set to false once OAuth is configured
      argocd_url                 = ""   # http://<LB-IP>
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = "" # e.g. "krukmaksym"
    }

    stage = {
      argocd_chart_version       = "7.8.13"
      environment                = "stage"
      server_insecure            = false
      admin_enabled              = false
      replace_on_failure         = false
      lb_source_ranges           = ["0.0.0.0/0"]
      argocd_url                 = ""
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = ""
    }

    prod = {
      argocd_chart_version       = "7.8.13"
      environment                = "prod"
      server_insecure            = false
      admin_enabled              = false
      replace_on_failure         = false
      lb_source_ranges           = ["0.0.0.0/0"]
      argocd_url                 = ""
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = ""
    }
  }
}

inputs = local.argocd[local.env]
