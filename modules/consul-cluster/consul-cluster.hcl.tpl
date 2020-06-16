datacenter = "hcpoc"
data_dir = "/var/lib/consul"
log_level = "INFO"
node_name = "${node_id}"
%{ for n in setsubtract(keys("${cluster_nodes}"), [node_id]) ~}
retry_join = ["${cluster_nodes[n]}"]
%{ endfor ~}
server = true
telemetry = {
   statsite_address = "127.0.0.1:2180"
}
ui = true