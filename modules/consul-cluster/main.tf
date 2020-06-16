resource "null_resource" "consul_cluster_node" {
  for_each = var.cluster_nodes
  provisioner "remote-exec" {
    script = "${path.module}/scripts/consul_cluster_init.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      timeout     = var.ssh_timeout
      private_key = var.ssh_private_key
      host        = var.cluster_nodes_public_ips[keys(var.cluster_nodes)[0]]
    }
  }
}