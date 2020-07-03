resource "null_resource" "consul_cluster_node_deploy_config" {
  triggers = {
    ids = join("-", var.cluster_nodes_ids)
  }

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
  destination = "/tmp/"

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.ssh_private_key
    timeout     = var.ssh_timeout
    host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
  }
}

provisioner "file" {
  content     = "echo VAULT_ADDR=${var.vault_address} VAULT_TOKEN=`cat /root/root_token`\n"
  destination = "vault.vars"

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.ssh_private_key
    timeout     = var.ssh_timeout
    host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
  }
}

provisioner "remote-exec" {
  inline = ["sudo mv vault.vars /root/vault.vars; sudo mv /tmp/consul.hcl /etc/consul.d/consul.hcl; sudo cp /tmp/*.hcl /home/centos; sudo chown -R centos: /home/centos/*; rm /tmp/*.hcl"]
  connection {
    type        = "ssh"
    user        = var.ssh_user
    timeout     = var.ssh_timeout
    private_key = var.ssh_private_key
    host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
  }
}
}

resource "null_resource" "consul_cluster_node_init" {
  count = length(var.cluster_nodes)
  depends_on = [
    null_resource.consul_cluster_node_deploy_config
  ]
  triggers = {
    nodes = length(keys(null_resource.consul_cluster_node_deploy_config)) > 0 ? join("-", [for k, v in null_resource.consul_cluster_node_deploy_config : v.id]) : ""
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/consul_cluster_init.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      timeout     = var.ssh_timeout
      private_key = var.ssh_private_key
      host        = var.cluster_nodes_public_ips[keys(var.cluster_nodes)[count.index]]
    }
  }
}
resource "null_resource" "consul_cluster_acl_bootstrap" {
  depends_on = [
    null_resource.consul_cluster_node_init
  ]
  provisioner "remote-exec" {
    script = "${path.module}/scripts/consul_acl_bootstrap.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      timeout     = var.ssh_timeout
      private_key = var.ssh_private_key
      host        = var.cluster_nodes_public_ips[keys(var.cluster_nodes)[0]]
    }
  }
}

resource "local_file" "ssh-key" {
  depends_on = [
    null_resource.consul_cluster_acl_bootstrap,
  ]
  sensitive_content = var.ssh_private_key
  filename          = "${path.module}/.ssh-key"
  file_permission   = "0600"
}

resource "null_resource" "copy_bootstrap_token" {
  depends_on = [
    local_file.ssh-key,
    null_resource.consul_cluster_acl_bootstrap
  ]
  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${path.module}/.ssh-key ${var.ssh_user}@${var.cluster_nodes_public_ips[keys(var.cluster_nodes)[0]]} 'sudo cat /root/bootstrap_token' > .bootstrap_token"
  }
}

# resource "null_resource" "consul_cluster_tokenize" {
#   depends_on = [
#     null_resource.copy_bootstrap_token,
#     null_resource.consul_cluster_acl_bootstrap,
#   ]
#   provisioner "remote-exec" {
#     script = "${path.module}/scripts/consul_tokenize.sh"
#     connection {
#       type        = "ssh"
#       user        = var.ssh_user
#       timeout     = var.ssh_timeout
#       private_key = var.ssh_private_key
#       host        = var.cluster_nodes_public_ips[keys(var.cluster_nodes)[0]]
#     }
#   }
# }