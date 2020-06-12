resource "null_resource" "consul_cluster_node" {
  for_each = var.cluster_nodes
}
