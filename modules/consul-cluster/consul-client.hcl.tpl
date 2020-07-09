datacenter = "hcpoc"
data_dir = "/var/lib/consul"
log_level = "INFO"
node_name = "${node_id}"
retry_join = [
   %{ for n in setsubtract(keys("${cluster_nodes}"), [node_id]) ~}
   "${cluster_nodes[n]}:8301",
   %{ endfor ~}
   %{ for n in setsubtract(keys("${cluster_nodes}"), [node_id]) ~}
   "${cluster_nodes[n]}:8301",
   %{ endfor ~}
]
telemetry = {
   statsite_address = "127.0.0.1:2180"
}
acl {
   enabled = true
   default_policy = "deny"
   enable_token_persistence = true
 }
ui = true
client_addr = "0.0.0.0"
connect {
   enabled = true
}
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true