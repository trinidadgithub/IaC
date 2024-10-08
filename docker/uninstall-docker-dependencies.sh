#!/bin/bash
echo "-----------------------------"
echo "Uninstall docker dependencies"
echo "-----------------------------"

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
