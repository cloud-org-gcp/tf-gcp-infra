#!/bin/bash
set -e
sleep 10
# Fetch metadata values and write to /etc/environment
echo "DB_USER=$(curl -s -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/DB_USER)" | sudo tee -a /etc/environment
echo "DB_PASSWORD=$(curl -s -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/DB_PASSWORD)" | sudo tee -a /etc/environment
echo "DB_HOST=$(curl -s -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/DB_HOST)" | sudo tee -a /etc/environment
echo "DB_NAME=$(curl -s -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/DB_NAME)" | sudo tee -a /etc/environment