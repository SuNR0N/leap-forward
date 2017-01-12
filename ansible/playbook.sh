#!/bin/bash
echo "Unsetting AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY environment variables"
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
echo "Setting AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY based on terraform.tfvars"
export AWS_ACCESS_KEY_ID=$(awk '$1=="access_key" { print $3 }' ../terraform.tfvars | awk '{ gsub(/"/, "") } 1')
export AWS_SECRET_ACCESS_KEY=$(awk '$1=="secret_key" { print $3 }' ../terraform.tfvars | awk '{ gsub(/"/, "") } 1')
echo "Running ansible Playbook"
ansible-playbook playbook.yaml
