#!/bin/bash
set -e

echo "Waiting for Consul up..."
consul_up=$(curl --silent --output /dev/null --write-out "%{http_code}" "127.0.0.1:8500/v1/status/leader") || consul_up=""
while [ $(curl --silent --output /dev/null --write-out "%{http_code}" "127.0.0.1:8500/v1/status/leader") != "200" ]; do
  echo "Waiting for Consul to get a leader..."
  sleep 5
  consul_up=$(curl --silent --output /dev/null --write-out "%{http_code}" "127.0.0.1:8500/v1/status/leader") || consul_up=""
done

echo "Bootstrapping ACLs..."
consul acl bootstrap | \
awk '(/Secret/ || /Accessor/)'| sudo tee /root/tokens && \
sleep 5s
export `sudo sh /root/vault.vars` && \
{ [ -z "`sudo cat /root/tokens | awk '/Secret/{print $2}'`" ] ||
  vault kv put secret/consul/bootstrap_token secretid="`sudo cat /root/tokens | awk '/Secret/{print $2}'`" accessorid="`sudo cat /root/tokens | awk '/Access/{print $2}'`"
} && \
sudo rm -f /root/tokens