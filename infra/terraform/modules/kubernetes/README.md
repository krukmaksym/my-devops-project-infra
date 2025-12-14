<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_kubernetes_cluster.k8s](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_cluster) | resource |
| [digitalocean_kubernetes_node_pool.monitoring](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scale"></a> [auto\_scale](#input\_auto\_scale) | Toggle to define default autoscaling behaviour | `bool` | `true` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | tflint-ignore: terraform\_unused\_declarations | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | DigitalOcean env to provision | `string` | n/a | yes |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | value | `string` | `"1.34.0-do.0"` | no |
| <a name="input_max_nodes"></a> [max\_nodes](#input\_max\_nodes) | Max nodes in node pool | `number` | `4` | no |
| <a name="input_min_nodes"></a> [min\_nodes](#input\_min\_nodes) | Min nodes in node pool | `number` | `2` | no |
| <a name="input_monitoring_auto_scale"></a> [monitoring\_auto\_scale](#input\_monitoring\_auto\_scale) | Enable autoscaling for the monitoring node pool | `bool` | `false` | no |
| <a name="input_monitoring_max_nodes"></a> [monitoring\_max\_nodes](#input\_monitoring\_max\_nodes) | Maximum number of nodes in the monitoring node pool when autoscaling is enabled | `number` | `2` | no |
| <a name="input_monitoring_min_nodes"></a> [monitoring\_min\_nodes](#input\_monitoring\_min\_nodes) | Minimum number of nodes in the monitoring node pool when autoscaling is enabled | `number` | `1` | no |
| <a name="input_monitoring_node_count"></a> [monitoring\_node\_count](#input\_monitoring\_node\_count) | Number of nodes in the monitoring node pool (used when autoscaling is disabled) | `number` | `1` | no |
| <a name="input_monitoring_node_size"></a> [monitoring\_node\_size](#input\_monitoring\_node\_size) | Droplet size for the monitoring node pool | `string` | `"s-2vcpu-2gb"` | no |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Default count of nodes in the K8s cluster | `number` | `2` | no |
| <a name="input_node_pool_labels"></a> [node\_pool\_labels](#input\_node\_pool\_labels) | Labels applied to the Kubernetes node pool | `map(string)` | <pre>{<br/>  "owner": "DevOps Team"<br/>}</pre> | no |
| <a name="input_node_size"></a> [node\_size](#input\_node\_size) | Default node size used by K8s cluster | `string` | `"s-2vcpu-2gb"` | no |
| <a name="input_region"></a> [region](#input\_region) | DigitalOcean region | `string` | `"fra1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied for resource | `set(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | DigitalOcean VPC id to pass | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_node_pool_id"></a> [app\_node\_pool\_id](#output\_app\_node\_pool\_id) | ID of the application node pool |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | CA certificate for the Kubernetes cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the DigitalOcean Kubernetes cluster |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | Access token for the Kubernetes cluster |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | API server endpoint of the Kubernetes cluster |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Raw kubeconfig for the Kubernetes cluster |
| <a name="output_monitoring_node_pool_id"></a> [monitoring\_node\_pool\_id](#output\_monitoring\_node\_pool\_id) | ID of the monitoring node pool |
<!-- END_TF_DOCS -->
