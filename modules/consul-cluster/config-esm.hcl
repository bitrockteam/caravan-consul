log_level = "INFO"

// Controls whether to enable logging to syslog.
enable_syslog = false

// The syslog facility to use, if enabled.
syslog_facility = ""

// The unique id for this agent to use when registering itself with Consul.
// If unconfigured, a UUID will be generated for the instance id.
// Note: do not reuse the same instance id value for other agents. This id
// must be unique to disambiguate different instances on the same host.
// Failure to maintain uniqueness will result in an already-exists error.
instance_id = "esm"

// The service name for this agent to use when registering itself with Consul.
consul_service = "consul-esm"

// The service tag for this agent to use when registering itself with Consul.
// ESM instances that share a service name/tag combination will have the work
// of running health checks and pings for any external nodes in the catalog
// divided evenly amongst themselves.
consul_service_tag = ""

// The directory in the Consul KV store to use for storing runtime data.
consul_kv_path = "consul-esm/"

// The node metadata values used for the ESM to qualify a node in the catalog
// as an "external node".
external_node_meta {
    "external-node" = "true"
}

// The length of time to wait before reaping an external node due to failed
// pings.
node_reconnect_timeout = "72h"

// The interval to ping and update coordinates for external nodes that have
// 'external-probe' set to true. By default, ESM will attempt to ping and
// update the coordinates for all nodes it is watching every 10 seconds.
node_probe_interval = "10s"

// Controls whether or not to disable calculating and updating node coordinates
// when doing the node probe. Defaults to false i.e. coordinate updates
// are enabled.
//disable_coordinate_updates

// The address of the local Consul agent. Can also be provided through the
// CONSUL_HTTP_ADDR environment variable.
http_addr = "localhost:8500"

// The ACL token to use when communicating with the local Consul agent. Can
// also be provided through the CONSUL_HTTP_TOKEN environment variable.
token = "<to_tmpl>"

// The Consul datacenter to use.
datacenter = "gcp-dc"

// The CA file to use for talking to Consul over TLS. Can also be provided
// though the CONSUL_CACERT environment variable.
ca_file = "/etc/consul.d/ca"

// The path to a directory of CA certs to use for talking to Consul over TLS.
// Can also be provided through the CONSUL_CAPATH environment variable.
//ca_path = ""

// The client cert file to use for talking to Consul over TLS. Can also be
// provided through the CONSUL_CLIENT_CERT environment variable.
cert_file = "/etc/consul.d/cert"

// The client key file to use for talking to Consul over TLS. Can also be
// provided through the CONSUL_CLIENT_KEY environment variable.
key_file = "/etc/consul.d/keyfile"

// The server name to use as the SNI host when connecting to Consul via TLS.
// Can also be provided through the CONSUL_TLS_SERVER_NAME environment
// variable.
//tls_server_name = ""

// The method to use for pinging external nodes. Defaults to "udp" but can
// also be set to "socket" to use ICMP (which requires root privileges).
ping_type = "udp"