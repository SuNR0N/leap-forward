#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CERTS_DIR="${DIR}/../certs"
KUBERNETES_TOKEN_PATH="${DIR}/../tokens/token.csv"
TERRAFORM_TFVARS_PATH="${DIR}/../terraform.tfvars"
ANSIBLE_DIR="${DIR}/../ansible_kube"

if [ ! -f ${TERRAFORM_TFVARS_PATH} ]; then
    echo "terraform.tfvars doest not exist in parent directory"
    exit 1
fi

echo "Setting AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY based on terraform.tfvars"
export AWS_ACCESS_KEY_ID=$(awk '$1=="access_key" { print $3 }' ${TERRAFORM_TFVARS_PATH} | awk '{ gsub(/"/, "") } 1')
export AWS_SECRET_ACCESS_KEY=$(awk '$1=="secret_key" { print $3 }' ${TERRAFORM_TFVARS_PATH} | awk '{ gsub(/"/, "") } 1')

if [ ! -d ${CERTS_DIR} ]; then
    echo "The following directory does not exist: ${CERTS_DIR}."
    echo "Please run 'gen_certs.sh' from parent directory"
    exit 1
fi

if [ ! -f ${KUBERNETES_TOKEN_PATH} ]; then
    echo "The following file does not exist: ${KUBERNETES_TOKEN_PATH}."
    echo "Please run 'gen_tokens.sh' from parent directory"
    exit 1
fi

echo "Setting KUBERNETES_TOKEN based on the randomly generated token for kubelet in ${KUBERNETES_TOKEN_PATH}"
export KUBERNETES_TOKEN=$(awk -F, '$2 == "kubelet"{print $1}' ${KUBERNETES_TOKEN_PATH})

echo "Running Playbook for Kubernetes"
cd ${ANSIBLE_DIR}
ansible-playbook kubernetes.yaml --extra-vars="KUBERNETES_AUTH_TOKEN_VALUE=${KUBERNETES_TOKEN}"
