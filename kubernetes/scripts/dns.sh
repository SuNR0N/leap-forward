#!/bin/bash
KUBEDNS_SERVICE="https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/services/kubedns.yaml"
KUBEDNS_DEPLOYMENT="https://raw.githubusercontent.com/kelseyhightower/kubernetes-the-hard-way/master/deployments/kubedns.yaml"

command -v kubectl >/dev/null 2>&1 || {
  echo >&2 "kubectl is not installed. Aborting.";
  exit 1;
}

echo "Creating the kubedns service"
kubectl create -f ${KUBEDNS_SERVICE}

echo "Creating the kubedns deployment"
kubectl create -f ${KUBEDNS_DEPLOYMENT}
