datacenter = "hcpoc"
data_dir = "/var/lib/consul"
log_level = "INFO"
node_name = "${node_id}"
bootstrap_expect = 3
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
   default_policy = "deny"
   enable_token_persistence = true
 }
ui = true
client_addr = "0.0.0.0"
connect {
   enabled = true
   #ca_provider = "vault"
   #ca_config {
   #     address = "http://localhost:8200"
   #     token = "/etc/consul.d/vault_token"
   #     root_pki_path = "pki"
   #     intermediate_pki_path = "pki-connect"
   # }
}
