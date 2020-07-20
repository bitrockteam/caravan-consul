resource "null_resource" "consul_cluster_node_deploy_config" {
  triggers = {
    ids = join("-", var.cluster_nodes_ids)
  }
  
  depends_on = [
    null_resource.vault_cluster_node_1_init,
    null_resource.vault_cluster_node_not_1_init,
    null_resource.vault_gcp_agent_config,
    null_resource.vault_certificates_sync
  ]

  for_each = var.cluster_nodes

  provisioner "file" {
    destination = "/tmp/cert.tmpl"
    content = file("${path.module}/cert.tmpl")

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = var.ssh_private_key
      timeout     = var.ssh_timeout
      host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    }
  }

  provisioner "file" {
    destination = "/tmp/keyfile.tmpl"
    content = file("${path.module}/keyfile.tmpl")

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = var.ssh_private_key
      timeout     = var.ssh_timeout
      host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    }
  }

  provisioner "file" {
    destination = "/tmp/ca.tmpl"
    content = file("${path.module}/ca.tmpl")

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = var.ssh_private_key
      timeout     = var.ssh_timeout
      host        = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    }
  }
  
  provisioner "file" {
    destination = "/tmp/consul.hcl.tmpl"
    content = <<-EOT
    ${templatefile(
    "${path.module}/consul-server.hcl.tmpl",
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
    destination = "/tmp/consul.hcl"
    content = <<-EOT
    ${templatefile(
    "${path.module}/consul-server.hcl",
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
  inline = ["sudo mv vault.vars /root/vault.vars; sudo mv /tmp/consul.hcl /etc/consul.d/consul.hcl && sudo mv /tmp/consul.hcl.tmpl /etc/consul.d/consul.hcl.tmpl && sudo mv /tmp/ca.tmpl /etc/consul.d/ca.tmpl && sudo mv /tmp/cert.tmpl /etc/consul.d/cert.tmpl && sudo mv /tmp/keyfile.tmpl /etc/consul.d/keyfile.tmpl"]
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
