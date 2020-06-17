resource "null_resource" "consul_cluster_node_deploy_config" {
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

  provisioner "file" {
    source      = "${path.module}/acls/"
    destination = "/tmp/acls/"
  }

  provisioner "remote-exec" {
    inline = ["sudo mv /tmp/consul.hcl /etc/consul.d/consul.hcl; sudo mv /tmp/acls /etc/consul.d/acls/"]
    connection {
      type        = "ssh"
      user        = var.ssh_user
      timeout     = var.ssh_timeout
      private_key = var.ssh_private_key
      host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    }
  }
}

resource "null_resource" "consul_cluster_node_1_init" {
  triggers = {
    nodes = null_resource.consul_cluster_node_deploy_config[keys(var.cluster_nodes)[0]].id
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

resource "null_resource" "consul_cluster_not_node_1_init" {
  count = length(var.cluster_nodes) - 1 < 0 ? 0 : length(var.cluster_nodes) - 1
  triggers = {
    nodes = join(",", keys(null_resource.consul_cluster_node_deploy_config))
  }
  # depends_on = [
  #   null_resource.consul_cluster_node_1_init,
  # ]

  provisioner "remote-exec" {
    script = "${path.module}/scripts/consul_cluster_init.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      timeout     = var.ssh_timeout
      private_key = var.ssh_private_key
      host        = var.cluster_nodes_public_ips[keys(var.cluster_nodes)[count.index + 1]]
    }
  }
}

resource "null_resource" "consul_cluster_acl_start" {
  depends_on = [
    null_resource.consul_cluster_not_node_1_init,
  ]
  provisioner "remote-exec" {
    inline = ["consul acl bootstrap"]
    connection {
      type        = "ssh"
      user        = var.ssh_user
      timeout     = var.ssh_timeout
      private_key = var.ssh_private_key
      host        = var.cluster_nodes_public_ips[keys(var.cluster_nodes)[0]]
    }
  }
}
