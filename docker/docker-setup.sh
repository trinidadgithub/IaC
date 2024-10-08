#!/bin/sh
#
echo "---------------------------"
echo "Uninstall old docker if any"
echo "---------------------------"
sudo apt-get remove docker docker-engine docker.io containerd runc

echo "-----------------------------------------"
echo "Update the apt package index and install "
echo "packages to allow apt to use a repository"
echo "over HTTPS"
echo "-----------------------------------------"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

echo "------------------------------"
echo "Add Docker's official GPG key:"
echo "------------------------------"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "--------------------"
echo "Setup the repository"
echo "--------------------"
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "----------------------------"
echo "Update the apt package index"
echo "----------------------------"
sudo apt-get update

echo "----------------------------------------------------"
echo "Install Docker Engin, containerd, and Docker Compose"
echo "----------------------------------------------------"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "-------------------------------------------------"
echo "Verfiy the docker engin is successfully installed"
echo "-------------------------------------------------"
sudo docker run hello-world
