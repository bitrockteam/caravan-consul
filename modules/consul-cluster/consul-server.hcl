datacenter = "${dc_name}"
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
   prometheus_retention_time = "30s"
   disable_hostname = true
}
acl {
   enabled = true
   default_policy = "deny"
   enable_token_persistence = true
 }
ui = true
client_addr = "0.0.0.0"
