locals {
  env = basename(dirname(get_terragrunt_dir()))

  # Shared GitOps config — single source of truth for all environments.
  # To promote stage/prod to a specific release, change gitops_revision per env.
  gitops_repo_url = "https://github.com/krukmaksym/my-devops-project-infra"
  gitops_revision = "main"

  # Phase 1 (this PR): Bootstrap ArgoCD + provision DigitalOcean LoadBalancer.
  #   - LB is created to reserve an external IP for future use.
  #   - ArgoCD is accessed via `kubectl port-forward svc/argocd-server -n argocd 8080:443`.
  #   - No loadBalancerSourceRanges set (lb_source_ranges = []).
  #
  # Phase 2: Enable HTTPS on the LB (TLS termination or cert-manager).
  #
  # Phase 3: Configure GitHub OAuth SSO via Dex:
  #   1. Create GitHub OAuth App with callback: https://<LB-IP>/api/dex/callback
  #   2. Fill in argocd_url, github_oauth_client_id/secret, github_org, github_admin_team
  #   3. Set admin_enabled = false, server_insecure = false
  #   4. Restrict lb_source_ranges to known CIDRs if needed
  #   5. Re-apply

  argocd = {
    dev = {
      argocd_chart_version       = "7.8.13"
      argocd_apps_chart_version  = "2.0.2"
      environment                = "dev"
      server_insecure            = true # Phase 1 only — access via port-forward
      admin_enabled              = true # Phase 1 only — disable once OAuth is configured
      replace_on_failure         = true
      lb_source_ranges           = [] # Phase 1 — no IP restriction, secured via port-forward
      argocd_url                 = ""
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = ""
      github_admin_team          = ""
      gitops_repo_url            = local.gitops_repo_url
      gitops_revision            = local.gitops_revision
    }

    stage = {
      argocd_chart_version       = "7.8.13"
      argocd_apps_chart_version  = "2.0.2"
      environment                = "stage"
      server_insecure            = false
      admin_enabled              = false
      replace_on_failure         = false
      lb_source_ranges           = []
      argocd_url                 = ""
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = ""
      github_admin_team          = ""
      gitops_repo_url            = local.gitops_repo_url
      gitops_revision            = local.gitops_revision
    }

    prod = {
      argocd_chart_version       = "7.8.13"
      argocd_apps_chart_version  = "2.0.2"
      environment                = "prod"
      server_insecure            = false
      admin_enabled              = false
      replace_on_failure         = false
      lb_source_ranges           = []
      argocd_url                 = ""
      github_oauth_client_id     = ""
      github_oauth_client_secret = ""
      github_org                 = ""
      github_admin_team          = ""
      gitops_repo_url            = local.gitops_repo_url
      gitops_revision            = local.gitops_revision
    }
  }
}

inputs = local.argocd[local.env]
