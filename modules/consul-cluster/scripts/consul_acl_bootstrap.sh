#!/bin/bash
set -exo pipefail

NODES=(
  %{ for node in nodes ~}
  ${node}
  %{ endfor ~}
)

HOST=${host}

echo "Checking consul nodes.."
for n in $${NODES[@]}; do
  if [[ "$n" != $HOST ]];
  then
    while ! curl --output /dev/null --silent --fail  http://$n:8500; do 
      sleep 5s
    done
    echo "Node $n is alive."
  fi
done

echo "Waiting for Consul up..."
consul_up=$(curl --silent --output /dev/null --write-out "%%{http_code}" "127.0.0.1:8500/v1/status/leader") || consul_up=""
while [ $consul_up != "200" ]; do
  echo "Waiting for Consul to get a leader..."
  sleep 5
  consul_up=$(curl --silent --output /dev/null --write-out "%%{http_code}" "127.0.0.1:8500/v1/status/leader") || consul_up=""
done

consul_acl=$(curl --silent "127.0.0.1:8500/v1/acl/login"  -d '{ "AuthMethod": "test", "BearerToken": "XXXX" }') || consul_acl=""
expected_consul_acl="ACL not found"
while [[ "$consul_acl" != "$expected_consul_acl" ]]; do
  echo "Check for Consul ACL..."
  curl --silent "127.0.0.1:8500/v1/acl/login"  -d '{ "AuthMethod": "test", "BearerToken": "XXXX" }'
  sleep 5
  consul_acl=$(curl --silent "127.0.0.1:8500/v1/acl/login"  -d '{ "AuthMethod": "test", "BearerToken": "XXXX" }') || consul_acl=""
done

echo "Raft peers:"
curl -s 127.0.0.1:8500/v1/status/peers

echo "Bootstrapping ACLs..."
consul acl bootstrap | \
awk '(/Secret/ || /Accessor/)'| sudo tee /root/tokens && \
sleep 5s
export `sudo sh /root/vault.vars` && \
{ [ -z "`sudo cat /root/tokens | awk '/Secret/{print $2}'`" ] ||
  vault kv put secret/consul/bootstrap_token secretid="`sudo cat /root/tokens | awk '/Secret/{print $2}'`" accessorid="`sudo cat /root/tokens | awk '/Access/{print $2}'`"
} && \
sudo rm -f /root/tokens
