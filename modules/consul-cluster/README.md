# Caravan Consul Cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.ssh-key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.consul_cluster_acl_bootstrap](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.consul_cluster_node_deploy_config](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.consul_cluster_node_init](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_nodes"></a> [cluster\_nodes](#input\_cluster\_nodes) | A map in form of 'node-name' => 'node's private IP' of the nodes to provision the cluster on | `map(any)` | n/a | yes |
| <a name="input_cluster_nodes_ids"></a> [cluster\_nodes\_ids](#input\_cluster\_nodes\_ids) | list of strings which are IDs of the instance resources and are used to `trigger` the provisioning of `null` resources on instance recreation | `list(string)` | n/a | yes |
| <a name="input_dc_name"></a> [dc\_name](#input\_dc\_name) | Name of the datacenter of the consul cluster | `string` | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | n/a | `string` | n/a | yes |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | n/a | `string` | n/a | yes |
| <a name="input_cluster_nodes_public_ips"></a> [cluster\_nodes\_public\_ips](#input\_cluster\_nodes\_public\_ips) | The public IPs of the node to SSH into them | `map(any)` | `null` | no |
| <a name="input_consul_home"></a> [consul\_home](#input\_consul\_home) | The directory where the consul's data is kept on the nodes | `string` | `"/var/lib/consul"` | no |
| <a name="input_license"></a> [license](#input\_license) | Consul license to use | `string` | `""` | no |
| <a name="input_service_dashboard_url_template"></a> [service\_dashboard\_url\_template](#input\_service\_dashboard\_url\_template) | A service dashboard URL template which allows users to click directly through to the relevant service-specific dashboard | `string` | `""` | no |
| <a name="input_ssh_bastion_host"></a> [ssh\_bastion\_host](#input\_ssh\_bastion\_host) | n/a | `string` | `null` | no |
| <a name="input_ssh_bastion_port"></a> [ssh\_bastion\_port](#input\_ssh\_bastion\_port) | n/a | `string` | `"22"` | no |
| <a name="input_ssh_bastion_private_key"></a> [ssh\_bastion\_private\_key](#input\_ssh\_bastion\_private\_key) | n/a | `string` | `null` | no |
| <a name="input_ssh_bastion_user"></a> [ssh\_bastion\_user](#input\_ssh\_bastion\_user) | n/a | `string` | `null` | no |
| <a name="input_ssh_timeout"></a> [ssh\_timeout](#input\_ssh\_timeout) | n/a | `string` | `"15s"` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | n/a | `string` | `"centos"` | no |
| <a name="input_vault_token_file"></a> [vault\_token\_file](#input\_vault\_token\_file) | n/a | `string` | `".root_token"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_consul_address"></a> [consul\_address](#output\_consul\_address) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
