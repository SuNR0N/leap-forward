#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOKENS_DIR="${DIR}/../tokens"

if [ -d $TOKENS_DIR ]
then
  echo 'Deleting existing token...'
  rm -rf $TOKENS_DIR && mkdir $TOKENS_DIR
else
  echo 'Creating directory for tokens...'
  mkdir $TOKENS_DIR
fi

echo 'Generating Auth token for kubernetes'
KUBERNETES_AUTH_TOKEN=$(openssl rand -base64 6)

echo 'Creating token.csv...'
cat > $TOKENS_DIR/token.csv <<EOF
${KUBERNETES_AUTH_TOKEN},admin,admin
${KUBERNETES_AUTH_TOKEN},scheduler,scheduler
${KUBERNETES_AUTH_TOKEN},kubelet,kubelet
EOF
