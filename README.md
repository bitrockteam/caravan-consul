# hashicorp-consul-baseline

#### ingress

On clustnode01

Set http for jaeger-query:

`/usr/local/bin/consul config write service-default.hcl`

Write config for ingress srv (set acl token with export before this):

`/usr/local/bin/consul config write ingress.hcl`

Run ingress:

`./ingress.sh &`

it saves logs in local ingress.log

#### consul-esm (external service monitoring)

On clustnode02

start service (redirect log somewhere):

`/usr/local/bin/consul-esm -config-file=config-esm.hcl`


#### terminating

On clustnode03

Register Elastic srv:

`curl --request PUT --data @elastic.json localhost:8500/v1/catalog/register`

Write terminating config:

`/usr/local/bin/consul config write terminating.hcl`
