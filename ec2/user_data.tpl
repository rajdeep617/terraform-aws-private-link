#!/bin/bash

set -e

LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
INTERFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/$${INTERFACE}/vpc-id)
echo "Welcome To Provider VPC: $${VPC_ID} From Machine: $${LOCAL_IP}" > /opt/bitnami/nginx/html/index.html

echo "${ec2_private_key}" > /home/bitnami/.ssh/id_rsa
chmod 400 /home/bitnami/.ssh/id_rsa
chown bitnami:bitnami /home/bitnami/.ssh/id_rsa