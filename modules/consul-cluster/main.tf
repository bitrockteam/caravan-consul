resource "null_resource" "consul_cluster_node" {
  for_each = var.cluster_nodes

  provisioner "file" {
    destination = "/tmp/consul.hcl"
    content = <<-EOT
    ${templatefile(
      "${path.module}/consul-cluster.hcl.tpl",
      {
        cluster_nodes = var.cluster_nodes
        node_id       = each.key
      }
    )}
    EOT
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = var.ssh_private_key
      timeout     = var.ssh_timeout
      host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    }
  }

  provisioner "remote-exec" {
    inline = ["sudo mv /tmp/consul.hcl /etc/consul.d/consul.hcl"]
    connection {
      type        = "ssh"
      user        = var.ssh_user
      timeout     = var.ssh_timeout
      private_key = var.ssh_private_key
      host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    }
  }

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