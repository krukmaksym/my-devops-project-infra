variable "monitoring_namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "retention_period" {
  description = "Data retention period"
  type        = string
  default     = "14d"
}

variable "vm_stack_chart_version" {
  description = "Version of the victoria-metrics-k8s-stack Helm chart to deploy"
  type        = string
}

variable "helm_values" {
  description = "List of extra raw values in YAML format to pass to helm"
  type        = list(string)
  default     = []
}
