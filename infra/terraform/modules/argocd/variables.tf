variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Helm chart version for argo-cd"
  type        = string
}

variable "environment" {
  description = "Environment name (used for LB naming)"
  type        = string
}

variable "lb_source_ranges" {
  description = "CIDRs allowed to reach the ArgoCD LoadBalancer. Empty list = no loadBalancerSourceRanges set (LB open, secured by HTTPS + auth)."
  type        = list(string)
  default     = []
}

variable "server_insecure" {
  description = "Disable TLS on the ArgoCD server (dev only — do not enable in stage/prod)"
  type        = bool
  default     = false
}

variable "admin_enabled" {
  description = "Enable the default admin account (disable and use OIDC for stage/prod)"
  type        = bool
  default     = false
}

variable "replace_on_failure" {
  description = "Allow Terraform to replace a failed Helm release (safe for dev, risky for prod)"
  type        = bool
  default     = false
}

variable "github_oauth_client_id" {
  description = "GitHub OAuth App client ID for Dex SSO"
  type        = string
  default     = ""
}

variable "github_oauth_client_secret" {
  description = "GitHub OAuth App client secret for Dex SSO"
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_org" {
  description = "GitHub organization — only members of this org can log in"
  type        = string
  default     = ""
}

variable "github_admin_team" {
  description = "GitHub team slug granted ArgoCD admin (e.g. 'platform'). Empty = all org members get admin."
  type        = string
  default     = ""
}

variable "argocd_url" {
  description = "External URL of ArgoCD (e.g. http://<LB-IP>) — required for OAuth callback"
  type        = string
  default     = ""
}

variable "gitops_repo_url" {
  description = "Git repository URL ArgoCD watches for Application manifests"
  type        = string
}

variable "gitops_revision" {
  description = "Git branch/tag ArgoCD tracks (e.g. main)"
  type        = string
  default     = "main"
}
