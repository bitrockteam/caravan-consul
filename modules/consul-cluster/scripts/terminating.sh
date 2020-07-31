#! /bin/bash

export CONSUL_HTTP_TOKEN=<TOKEN>

/usr/local/bin/consul connect envoy -gateway=terminating -register -service monitoring-services-gateway -address '{{ GetInterfaceIP "eth0" }}:8443' -ca-file=/etc/consul.d/ca -client-cert=/etc/consul.d/cert -client-key=/etc/consul.d/keyfile -grpc-addr=https://localhost:8502 &> terminating.log