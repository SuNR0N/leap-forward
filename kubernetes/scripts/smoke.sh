#!/bin/bash
SECURITY_GROUP_NAME="nk-kubernetes-security-group"
KUBERNETES_WORKER_0_NAME="nk-kubernetes-worker-0"

command -v kubectl >/dev/null 2>&1 || {
  echo >&2 "kubectl is not installed. Aborting.";
  exit 1;
}

echo "Deleting existing nginx deployment"
kubectl delete deployments/nginx

echo "Creating nginx deployment"
kubectl run nginx --image=nginx --port=80 --replicas=3

echo "Getting pods information"
kubectl get pods -o wide

echo "Exposing NodePort of nginx deployment"
kubectl expose deployment nginx --type NodePort

echo "Getting the NodePort for the nginx service"

NODE_PORT=$(kubectl get svc nginx --output=jsonpath='{range .spec.ports[0]}{.nodePort}')

echo "The NodePort of the nginx service is ${NODE_PORT}"

command -v aws >/dev/null 2>&1 || {
  echo >&2 "aws is not installed. Aborting.";
  exit 1;
}

command -v jq >/dev/null 2>&1 || {
  echo >&2 "jq is not installed. Aborting.";
  exit 1;
}

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --filters "Name=tag:Name,Values=${SECURITY_GROUP_NAME}" | jq -r '.SecurityGroups[].GroupId')

echo "Creating ingress rule on ${SECURITY_GROUP_NAME} for port ${NODE_PORT}"

aws ec2 authorize-security-group-ingress \
  --group-id ${SECURITY_GROUP_ID} \
  --protocol tcp \
  --port ${NODE_PORT} \
  --cidr 0.0.0.0/0

echo "Getting the Public IP for ${KUBERNETES_WORKER_0_NAME}"

KUBERNETES_WORKER_0_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${KUBERNETES_WORKER_0_NAME}" | jq -j '.Reservations[].Instances[].PublicIpAddress')

echo "The Public IP of ${KUBERNETES_WORKER_0_NAME} is ${KUBERNETES_WORKER_0_IP}"

CURL_CMD="curl http://${KUBERNETES_WORKER_0_IP}:${NODE_PORT}"

echo "Testing the nginx service: ${CURL_CMD}"
${CURL_CMD}
