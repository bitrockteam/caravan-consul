variable "cluster_nodes" {
  type        = map(any)
}
variable "cluster_nodes_public_ips" {
  type    = map(any)
  default = null
}
variable "dc_name" {
  type = string
}
variable "consul_home" {
  type    = string
  default = "/var/lib/consul"
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
  type = list(string)
}
variable "vault_address" {
  type = string
}
variable "vault_token_file" {
  type    = string
  default = ".root_token"
}
