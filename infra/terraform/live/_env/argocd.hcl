locals {
  env = basename(dirname(get_terragrunt_dir()))

  # Phase 1 (this PR): Bootstrap ArgoCD + provision DigitalOcean LoadBalancer.
  #   - LB is created to reserve an external IP for future use.
  #   - ArgoCD is accessed via `kubectl port-forward svc/argocd-server -n argocd 8080:443`.
  #   - No loadBalancerSourceRanges set (lb_source_ranges = []).
  #
  # Phase 2: Enable HTTPS on the LB (TLS termination or cert-manager).
  #
  # Phase 3: Configure GitHub OAuth SSO via Dex:
  #   1. Create GitHub OAuth App with callback: https://<LB-IP>/api/dex/callback
  #   2. Fill in argocd_url, github_oauth_client_id/secret, github_org
  #   3. Set admin_enabled = false, server_insecure = false
  #   4. Restrict lb_source_ranges to known CIDRs if needed
  #   5. Re-apply

  argocd = {
    dev = {
      argocd_chart_version       = "7.8.13"
      environment                = "dev"
      server_insecure            = true # Phase 1 only — access via port-forward
      admin_enabled              = true # Phase 1 only — disable once OAuth is configured
      replace_on_failure         = true
      lb_source_ranges           = [] # Phase 1 — no IP restriction, secured via port-forward
      argocd_url                 = ""
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = ""
    }

    stage = {
      argocd_chart_version       = "7.8.13"
      environment                = "stage"
      server_insecure            = false
      admin_enabled              = false
      replace_on_failure         = false
      lb_source_ranges           = []
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
      lb_source_ranges           = []
      argocd_url                 = ""
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = ""
    }
  }
}

inputs = local.argocd[local.env]
