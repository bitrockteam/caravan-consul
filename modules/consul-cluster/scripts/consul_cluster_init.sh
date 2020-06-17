#!/bin/bash
set -e
sudo ls -la /etc/consul.d/
sudo systemctl start consul &&  \
sleep 10s && \
systemctl status consul && \
awk '/SecretID/{print $2}' | \
sudo tee /root/bootstrap_token