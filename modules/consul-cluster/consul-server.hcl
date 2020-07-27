datacenter = "hcpoc"
data_dir = "/var/lib/consul"
log_level = "DEBUG"
node_name = "${node_id}"
bootstrap_expect = 3
retry_join = [
   %{ for n in setsubtract(keys("${cluster_nodes}"), [node_id]) ~}
   "${cluster_nodes[n]}:8301",
   %{ endfor ~}
]
server = true
ports {
  grpc  = 8502
  https = 8501
  http  = 8500
}
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
