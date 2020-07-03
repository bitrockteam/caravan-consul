#!/bin/bash
set -e
consul acl bootstrap | \
awk '(/Secret/ || /Accessor/)'| sudo tee /root/tokens && \
sleep 5s
export `sudo sh /root/vault.vars` && \
vault kv put secret/consul/bootstrap_token secretid="`sudo cat /root/tokens | awk '/Secret/{print $2}'`" && \
vault kv put secret/consul/bootstrap_token accessorid="`sudo cat /root/tokens | awk '/Access/{print $2}'`"