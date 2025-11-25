# variable "do_token" {
#   type = string
#   sensitive = true
# }

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "fra1"
}

variable "environment" {
  description = "DigitalOcean env to provision"
  type        = string
}

variable "k8s_version" {
  description = "value"
  type        = string
  default     = "1.34.0-do.0"
}

variable "vpc_id" {
  description = "DigitalOcean VPC id to pass"
  type        = string
}

variable "node_size" {
  description = "Default node size used by K8s cluster"
  type        = string
  default     = "s-2vcpu-2gb"
}

variable "node_count" {
  description = "Default count of nodes in the K8s cluster"
  type        = number
  default     = 2
}

variable "auto_scale" {
  description = "Toggle to define default autoscaling behaviour"
  type        = bool
  default     = true
}

variable "min_nodes" {
  description = "Min nodes in node pool"
  type        = number
  default     = 2
}

variable "max_nodes" {
  description = "Max nodes in node pool"
  type        = number
  default     = 4
}

variable "node_pool_labels" {
  description = "Labels applied to the Kubernetes node pool"
  type        = map(string)
  default = {
    owner = "DevOps Team"
  }
}

variable "monitoring_node_size" {
  description = "Droplet size for the monitoring node pool"
  type        = string
  default     = "s-2vcpu-2gb"
}

variable "monitoring_node_count" {
  description = "Number of nodes in the monitoring node pool (used when autoscaling is disabled)"
  type        = number
  default     = 1
}

variable "monitoring_auto_scale" {
  description = "Enable autoscaling for the monitoring node pool"
  type        = bool
  default     = false
}

variable "monitoring_min_nodes" {
  description = "Minimum number of nodes in the monitoring node pool when autoscaling is enabled"
  type        = number
  default     = 1
}

variable "monitoring_max_nodes" {
  description = "Maximum number of nodes in the monitoring node pool when autoscaling is enabled"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags to be applied for resource"
  type        = set(string)
}