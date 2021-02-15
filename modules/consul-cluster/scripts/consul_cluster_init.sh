#!/bin/bash
set -e

echo "Start Consul service.."
sudo systemctl start consul

echo "wait cold start.."
sleep 10s

echo "Is service up?"
while ! curl --output /dev/null --silent --fail  http://localhost:8500; do 
  sleep 5s
done
echo "Yes."
