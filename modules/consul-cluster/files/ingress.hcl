Kind = "ingress-gateway"
Name = "ingress-service"

#TLS {
#  Enabled = true
#}

Listeners = [
 {
   Port = 8080
   Protocol = "http"
   Services = [
     {
       Name = "jaeger-query",
       Hosts = ["bmed.hcpoc.bitrock.it", "bmed.hcpoc.bitrock.it:8080","jaeger-query.ingress.hcpoc.consul"]
     }
   ]
 }
]
