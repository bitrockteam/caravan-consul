export CONSUL_HTTP_TOKEN=`sudo cat /root/bootstrap_token` && \
consul acl policy create -name "agent-token" -description "Agent Token Policy" -rules @cluster-node-agent.hcl && \
consul acl token create -description "Agent Token" -policy-name "agent-token"
consul acl policy create -name "ui-token" -description "UI Token Policy" -rules @operator-ui.hcl && \
consul acl token create -description "UI Token" -policy-name "ui-token"|
awk '/SecretID/{print $2}' | \
sudo tee /root/ui_token
export `sudo sh /root/vault.vars` && \
vault kv put secret/consul/ui_token token="`sudo cat /root/ui_token`" && \
sudo rm /root/ui_token