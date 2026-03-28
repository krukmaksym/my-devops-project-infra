locals {
  env = basename(dirname(get_terragrunt_dir()))

  # GitOps repository — shared across all environments.
  gitops_repo_url = "https://github.com/krukmaksym/my-devops-project-infra"

  # Per-environment GitOps revision (branch or tag).
  # dev always tracks main. stage/prod are pinned to a release tag and
  # promoted deliberately via the "Promote to Environment" GitHub Actions
  # workflow (.github/workflows/promote.yml), which creates the tag and
  # opens a PR bumping the revision here.
  #
  # To promote manually:
  #   1. git tag v1.2.3 && git push origin v1.2.3
  #   2. Update gitops_revision_stage / gitops_revision_prod below
  #   3. Commit, push, open PR → merge → terragrunt apply argocd
  gitops_revision_dev   = "main"
  gitops_revision_stage = "main" # TODO: pin to a release tag once stage cluster is provisioned
  gitops_revision_prod  = "main" # TODO: pin to a release tag once prod cluster is provisioned

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
      gitops_revision            = local.gitops_revision_dev
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
      gitops_revision            = local.gitops_revision_stage
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
      gitops_revision            = local.gitops_revision_prod
    }
  }
}

inputs = local.argocd[local.env]
