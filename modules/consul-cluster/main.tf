resource "null_resource" "consul_cluster_node_deploy_config" {
  triggers = {
    ids = join("-", var.cluster_nodes_ids)
  }

  for_each = var.cluster_nodes

  provisioner "file" {
    destination = "/tmp/cert.tmpl"
    content = <<-EOT
    ${templatefile(
    "${path.module}/cert.tmpl",
    {
      dc_name = var.dc_name
    }
)}
    EOT

connection {
  type                = "ssh"
  user                = var.ssh_user
  private_key         = var.ssh_private_key
  timeout             = var.ssh_timeout
  host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
  bastion_host        = var.ssh_bastion_host
  bastion_port        = var.ssh_bastion_port
  bastion_private_key = var.ssh_bastion_private_key
  bastion_user        = var.ssh_bastion_user
}
}

provisioner "file" {
  destination = "/tmp/keyfile.tmpl"
  content = <<-EOT
    ${templatefile(
  "${path.module}/keyfile.tmpl",
  {
    dc_name = var.dc_name
  }
)}
    EOT

connection {
  type                = "ssh"
  user                = var.ssh_user
  private_key         = var.ssh_private_key
  timeout             = var.ssh_timeout
  host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
  bastion_host        = var.ssh_bastion_host
  bastion_port        = var.ssh_bastion_port
  bastion_private_key = var.ssh_bastion_private_key
  bastion_user        = var.ssh_bastion_user
}
}

provisioner "file" {
  destination = "/tmp/ca.tmpl"
  content     = file("${path.module}/ca.tmpl")

  connection {
    type                = "ssh"
    user                = var.ssh_user
    private_key         = var.ssh_private_key
    timeout             = var.ssh_timeout
    host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    bastion_host        = var.ssh_bastion_host
    bastion_port        = var.ssh_bastion_port
    bastion_private_key = var.ssh_bastion_private_key
    bastion_user        = var.ssh_bastion_user
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
    dc_name       = var.dc_name
  }
)}
    EOT
connection {
  type                = "ssh"
  user                = var.ssh_user
  private_key         = var.ssh_private_key
  timeout             = var.ssh_timeout
  host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
  bastion_host        = var.ssh_bastion_host
  bastion_port        = var.ssh_bastion_port
  bastion_private_key = var.ssh_bastion_private_key
  bastion_user        = var.ssh_bastion_user
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
    dc_name       = var.dc_name
  }
)}
    EOT
connection {
  type                = "ssh"
  user                = var.ssh_user
  private_key         = var.ssh_private_key
  timeout             = var.ssh_timeout
  host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
  bastion_host        = var.ssh_bastion_host
  bastion_port        = var.ssh_bastion_port
  bastion_private_key = var.ssh_bastion_private_key
  bastion_user        = var.ssh_bastion_user
}
}

provisioner "file" {
  content     = "echo VAULT_ADDR=${var.vault_address} VAULT_TOKEN=`cat /root/root_token`\n"
  destination = "vault.vars"

  connection {
    type                = "ssh"
    user                = var.ssh_user
    private_key         = var.ssh_private_key
    timeout             = var.ssh_timeout
    host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    bastion_host        = var.ssh_bastion_host
    bastion_port        = var.ssh_bastion_port
    bastion_private_key = var.ssh_bastion_private_key
    bastion_user        = var.ssh_bastion_user
  }
}

provisioner "remote-exec" {
  inline = ["sudo mv vault.vars /root/vault.vars; sudo mv /tmp/consul.hcl /etc/consul.d/consul.hcl && sudo mv /tmp/consul.hcl.tmpl /etc/consul.d/consul.hcl.tmpl && sudo mv /tmp/ca.tmpl /etc/consul.d/ca.tmpl && sudo mv /tmp/cert.tmpl /etc/consul.d/cert.tmpl && sudo mv /tmp/keyfile.tmpl /etc/consul.d/keyfile.tmpl"]
  connection {
    type                = "ssh"
    user                = var.ssh_user
    timeout             = var.ssh_timeout
    private_key         = var.ssh_private_key
    host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[each.key] : each.value
    bastion_host        = var.ssh_bastion_host
    bastion_port        = var.ssh_bastion_port
    bastion_private_key = var.ssh_bastion_private_key
    bastion_user        = var.ssh_bastion_user
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
      type                = "ssh"
      user                = var.ssh_user
      timeout             = var.ssh_timeout
      private_key         = var.ssh_private_key
      host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[keys(var.cluster_nodes)[count.index]] : var.cluster_nodes[keys(var.cluster_nodes)[count.index]]
      bastion_host        = var.ssh_bastion_host
      bastion_port        = var.ssh_bastion_port
      bastion_private_key = var.ssh_bastion_private_key
      bastion_user        = var.ssh_bastion_user
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
      type                = "ssh"
      user                = var.ssh_user
      timeout             = var.ssh_timeout
      private_key         = var.ssh_private_key
      host                = var.cluster_nodes_public_ips != null ? var.cluster_nodes_public_ips[keys(var.cluster_nodes)[0]] : var.cluster_nodes[keys(var.cluster_nodes)[0]]
      bastion_host        = var.ssh_bastion_host
      bastion_port        = var.ssh_bastion_port
      bastion_private_key = var.ssh_bastion_private_key
      bastion_user        = var.ssh_bastion_user
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
