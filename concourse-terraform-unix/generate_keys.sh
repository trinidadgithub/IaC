#!/bin/bash

# Create a directory for the keys
mkdir -p keys

# Generate keys for TSA and worker
ssh-keygen -t rsa -b 2048 -f keys/tsa_host_key -N ""
ssh-keygen -t rsa -b 2048 -f keys/worker_key -N ""

# Copy the public key for the authorized workers file
cp keys/worker_key.pub keys/authorized_worker_keys

# Generate session signing key
openssl genrsa -out keys/session_signing_key 2048

# Set permissions
chmod 600 keys/tsa_host_key keys/worker_key keys/session_signing_key
chmod 644 keys/tsa_host_key.pub keys/worker_key.pub keys/authorized_worker_keys

echo "Keys generated and permissions set."
