#!/bin/bash
set -e
consul acl bootstrap | \
awk '/SecretID/{print $2}' | \
sudo tee /root/bootstrap_token && \
sleep 5s
export `sudo sh /root/vault.vars` && \
vault kv put secret/consul/bootstrap_token token="`sudo cat /root/bootstrap_token`"