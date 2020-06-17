datacenter = "hcpoc"
data_dir = "/var/lib/consul"
log_level = "INFO"
node_name = "${node_id}"
%{if "${node_id}" == "cluster-node-1" ~}
bootstrap = true
%{ else ~}
bootstrap_expect = 3
%{ endif ~}
retry_join = [
   %{ for n in setsubtract(keys("${cluster_nodes}"), [node_id]) ~}
   "${cluster_nodes[n]}:8301",
   %{ endfor ~}
]
server = true
telemetry = {
   statsite_address = "127.0.0.1:2180"
}
acl {
   enabled = true
   default_policy = "allow"
   enable_token_persistence = true
 }
ui = true
client_addr = "0.0.0.0"