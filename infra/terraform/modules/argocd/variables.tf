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
  description = "CIDRs allowed to reach the ArgoCD LoadBalancer"
  type        = list(string)

  validation {
    condition     = length(var.lb_source_ranges) > 0
    error_message = "lb_source_ranges must not be empty — restrict LoadBalancer access to known CIDRs."
  }
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

variable "helm_values" {
  description = "Additional Helm values to pass to the ArgoCD chart"
  type        = list(string)
  default     = []
}
