#!/bin/bash
WORKER_NAME_PREFIX="nk-kubernetes-worker-"
ROUTE_TABLE_NAME="nk-route-table-igw"

command -v kubectl >/dev/null 2>&1 || {
  echo >&2 "kubectl is not installed. Aborting.";
  exit 1;
}

KUBERNETES_WORKERS=$(kubectl get nodes --output=jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address},{.spec.podCIDR}{"\n"}{end}')

command -v aws >/dev/null 2>&1 || {
  echo >&2 "aws is not installed. Aborting.";
  exit 1;
}

command -v jq >/dev/null 2>&1 || {
  echo >&2 "jq is not installed. Aborting.";
  exit 1;
}

ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=${ROUTE_TABLE_NAME}" | jq -r '.RouteTables[].RouteTableId')

for i in ${KUBERNETES_WORKERS[@]}; do
  WORKER_IP=$(echo ${i} | cut -f1 -d,)
  WORKER_NAME=${WORKER_NAME_PREFIX}${WORKER_IP: -1}
  WORKER_POD_CIDR=$(echo ${i} | cut -f2 -d,)
  WORKER_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${WORKER_NAME}" | jq -j '.Reservations[].Instances[].InstanceId')

  echo "Setting up route for worker ${WORKER_NAME} (IP: ${WORKER_IP}, POD CIDR: ${WORKER_POD_CIDR}, Instance ID: ${WORKER_INSTANCE_ID})"

  aws ec2 create-route --route-table-id ${ROUTE_TABLE_ID} --destination-cidr-block ${WORKER_POD_CIDR} --instance-id ${WORKER_INSTANCE_ID}
done
