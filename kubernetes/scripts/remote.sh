#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PEM_CA_PATH="${DIR}/../certs/ca.pem"
ELB_DNS=$(terraform output --state=${DIR}/../terraform.tfstate elb_dns)
KUBERNETES_TOKEN_PATH="${DIR}/../tokens/token.csv"
KUBERNETES_TOKEN_VALUE=$(awk -F, '$2 == "admin"{print $1}' ${KUBERNETES_TOKEN_PATH})

command -v kubectl >/dev/null 2>&1 || {
  echo >&2 "kubectl is not installed. Aborting.";
  exit 1;
}

echo "Configuring Kubernetes cluster"
kubectl config set-cluster leapforward_kubernetes \
  --certificate-authority=${PEM_CA_PATH} \
  --embed-certs=true \
  --server=https://${ELB_DNS}:6443

echo "Configuring credentials"
kubectl config set-credentials admin --token ${KUBERNETES_TOKEN_VALUE}

echo "Setting context"
kubectl config set-context default-context \
  --cluster=leapforward_kubernetes \
  --user=admin

kubectl config use-context default-context
