#!/bin/bash
CERTS_DIR="certs"

if [ -d $CERTS_DIR ]
then
  echo 'Deleting existing certificates...'
  rm -rf $CERTS_DIR && mkdir $CERTS_DIR
else
  echo 'Creating directory for certificates...'
  mkdir $CERTS_DIR
fi

echo 'Creating ca-config.json...'
echo '{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}' > $CERTS_DIR/ca-config.json

echo 'Creating ca-csr.json...'
echo '{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}' > $CERTS_DIR/ca-csr.json

echo 'Generating the CA certificate and private key...'
cfssl gencert -initca $CERTS_DIR/ca-csr.json | cfssljson -bare $CERTS_DIR/ca

echo 'Verifying CA certificate...'
openssl x509 -in $CERTS_DIR/ca.pem -text -noout

echo 'Creating kubernetes-csr.json ...'
cat > $CERTS_DIR/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "nk-kubernetes-worker-0",
    "nk-kubernetes-worker-1",
    "nk-kubernetes-worker-2",
    "ip-10-240-0-20",
    "ip-10-240-0-21",
    "ip-10-240-0-22",
    "10.32.0.1",
    "10.240.0.10",
    "10.240.0.11",
    "10.240.0.12",
    "10.240.0.20",
    "10.240.0.21",
    "10.240.0.22",
    "$(terraform output elb_dns)",
    "127.0.0.1"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Cluster",
      "ST": "Oregon"
    }
  ]
}
EOF

echo 'Generating the Kubernetes certificate and private key...'
cfssl gencert -ca=$CERTS_DIR/ca.pem -ca-key=$CERTS_DIR/ca-key.pem -config=$CERTS_DIR/ca-config.json -profile=kubernetes $CERTS_DIR/kubernetes-csr.json | cfssljson -bare $CERTS_DIR/kubernetes

echo 'Verifying Kubernetes certificate...'
openssl x509 -in $CERTS_DIR/kubernetes.pem -text -noout
