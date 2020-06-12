variable "cluster_nodes" {
  type = map(any)
}
variable "cluster_nodes_public_ips" {
  type = map(any)
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
