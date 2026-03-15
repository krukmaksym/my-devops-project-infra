variable "argocd_namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Helm chart version for argo-cd"
  type        = string
}

variable "lb_source_ranges" {
  description = "CIDRs allowed to reach the ArgoCD LoadBalancer (empty list = unrestricted)"
  type        = list(string)
}

variable "helm_values" {
  description = "Additional Helm values to pass to the ArgoCD chart"
  type        = list(string)
  default     = []
}
