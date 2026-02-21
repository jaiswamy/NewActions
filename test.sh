#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

sudo apt install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo apt  install docker-compose

# Allow ubuntu user to run docker
sudo usermod -aG docker ubuntu

# Install AWS CLI (for ECR pull)
sudo apt install -y awscli
