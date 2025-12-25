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

variable "helm_values" {
  description = "List of extra raw values in YAML format to pass to helm"
  type        = list(string)
  default     = []
}
