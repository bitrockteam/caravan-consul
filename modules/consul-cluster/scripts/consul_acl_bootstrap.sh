#!/bin/bash
set -e
consul acl bootstrap | \
awk '/SecretID/{print $2}' | \
sudo tee /root/bootstrap_token && \
sleep 5s