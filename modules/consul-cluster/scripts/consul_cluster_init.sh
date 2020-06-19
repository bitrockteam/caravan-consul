#!/bin/bash
set -e
sudo ls -la /etc/consul.d/
sudo systemctl start consul &&  \
sleep 10s && \
systemctl status consul 
# && \
# consul acl policy create -name cluster-node-1-agent -rules @cluster-node-1.hcl && \
# consul acl policy create -name cluster-node-2-agent -rules @cluster-node-2.hcl && \
# consul acl policy create -name cluster-node-3-agent -rules @cluster-node-3.hcl && \
