# Usage

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| local | n/a |
| null | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_nodes | cluste node | `map(any)` | n/a | yes |
| cluster\_nodes\_ids | n/a | `list(string)` | n/a | yes |
| cluster\_nodes\_public\_ips | n/a | `map(any)` | `null` | no |
| consul\_home | n/a | `string` | `"/var/lib/consul"` | no |
| dc\_name | n/a | `string` | n/a | yes |
| ssh\_bastion\_host | n/a | `string` | `null` | no |
| ssh\_bastion\_port | n/a | `string` | `"22"` | no |
| ssh\_bastion\_private\_key | n/a | `string` | `null` | no |
| ssh\_bastion\_user | n/a | `string` | `null` | no |
| ssh\_private\_key | n/a | `string` | n/a | yes |
| ssh\_timeout | n/a | `string` | `"15s"` | no |
| ssh\_user | n/a | `string` | `"centos"` | no |
| vault\_address | n/a | `string` | n/a | yes |
| vault\_token\_file | n/a | `string` | `".root_token"` | no |

## Outputs

| Name | Description |
|------|-------------|
| consul\_address | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
