datacenter = "hcpoc"
data_dir = "/var/lib/consul"
log_level = "INFO"
%{ for n in keys("${cluster_nodes}") ~}
node_name = "${cluster_nodes[n]}"
%{ endfor ~}
server = true
telemetry = {
   statsite_address = "127.0.0.1:2180"
}
  