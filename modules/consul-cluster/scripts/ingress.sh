#! /bin/bash

export CONSUL_HTTP_TOKEN=<TOKEN>

/usr/local/bin/consul connect envoy -gateway=ingress -register -service ingress-service -address '{{ GetInterfaceIP "eth0" }}:8888' -ca-file=/etc/consul.d/ca -client-cert=/etc/consul.d/cert -client-key=/etc/consul.d/keyfile -grpc-addr=https://localhost:8502 &> ingress.log