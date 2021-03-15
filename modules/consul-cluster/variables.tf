variable "cluster_nodes" {
  type        = map(any)
  description = "A map in form of 'node-name' => 'node's private IP' of the nodes to provision the cluster on"
}
variable "cluster_nodes_public_ips" {
  type        = map(any)
  description = "The public IPs of the node to SSH into them"
  default     = null
}
variable "dc_name" {
  description = "Name of the datacenter of the consul cluster"
  type        = string
}
variable "service_dashboard_url_template" {
  description = "A service dashboard URL template which allows users to click directly through to the relevant service-specific dashboard"
  type        = string
  default     = ""
}
variable "consul_home" {
  type        = string
  description = "The directory where the consul's data is kept on the nodes"
  default     = "/var/lib/consul"
}
variable "ssh_private_key" {
  type = string
}
variable "ssh_user" {
  type    = string
  default = "centos"
}
variable "ssh_timeout" {
  type    = string
  default = "15s"
}
variable "ssh_bastion_host" {
  type    = string
  default = null
}
variable "ssh_bastion_port" {
  type    = string
  default = "22"
}
variable "ssh_bastion_private_key" {
  type    = string
  default = null
}
variable "ssh_bastion_user" {
  type    = string
  default = null
}
variable "cluster_nodes_ids" {
  type        = list(string)
  description = "list of strings which are IDs of the instance resources and are used to `trigger` the provisioning of `null` resources on instance recreation"
}
variable "vault_address" {
  type = string
}
variable "vault_token_file" {
  type    = string
  default = ".root_token"
}
variable "license" {
  type        = string
  default     = ""
  description = "Consul license to use"
}
