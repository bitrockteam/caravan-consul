sudo cd /etd/consul.d/acls && \
consul acl policy create -name "agent-token" -description "Agent Token Policy" -rules @cluster-node-agent.hcl && \
consul acl token create -description "Agent Token" -policy-name "agent-token"