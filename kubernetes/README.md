# Deploying a Kubernetes cluster on AWS

Bootstrap Kubernetes in an automated fashion. Based on [Kelsey Hightower's Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

## Prerequisites

- Locally installed `terraform` (https://www.terraform.io/downloads.html)
- Locally installed `ansible` (http://docs.ansible.com/ansible/intro_installation.html)
- Locally installed `python`
  - AWS SDK for Python (https://aws.amazon.com/sdk-for-python/)
- Locally installed AWS CLI (https://aws.amazon.com/cli/)
- Locally installed `jq` (https://stedolan.github.io/jq/download/)
- Locally installed `cfssl` and `cfssljson` (https://pkg.cfssl.org)
- Locally installed `kubectl` (https://kubernetes.io/docs/user-guide/prereqs/)

### Generating Key Pair for accessing EC2 instances

```
ssh-keygen -t rsa -C "leapforward_kubernetes" -P '' -f ~/.ssh/leapforward_kubernetes
ssh-add ~/.ssh/leapforward_kubernetes
```

### Providing values for predefined variables through `terraform.tfvars`

```
touch terraform.tfvars
```

Set the required variables
  - access_key
  - secret_key
  - ssh_key_name
  - my_cidr

### Provisioning the infrastructure

```
terraform apply
```

### Getting useful IP and DNS addresses from terrafrom once the infrastructure is provisioned

```
terraform output elb_dns
terraform output kubernetes_controller_public_dns
terraform output kubernetes_controller_public_ips
terraform output kubernetes_worker_public_dns
terraform output kubernetes_worker_public_ips
terraform output kubernetes_worker_private_ips
```

### Accessing the EC2 instances through SSH once the infrastructure is provisioned

All instances can be accessed via their public DNS / IP addresses:

```
ssh ubuntu@hostname
```

### Installing components

#### Generating TLS certificates

```
scripts/gen_certs.sh
```

**Verification**

Ensure that the `certs` directory exists within your project and contains the following files:
  - `ca-config.json`
  - `ca-csr.json`
  - `ca-key.pem`
  - `ca.csr`
  - `ca.pem`
  - `kubernetes-csr.json`
  - `kubernetes-key.pem`
  - `kubernetes.csr`
  - `kubernetes.pem`

#### Generating tokens for the Kubernetes components

```
scripts/gen_tokens.sh
```

**Verification**

Ensure that the `tokens` directory exists within your project and contains the following file:
  - `token.csv`

#### Running the Ansible playbook

Run the following script which will bootstrap your Kubernetes nodes:
  - Copies over the generated TLS certificates to your  `kubernetes-controller` and  `kubernetes-worker` nodes
  - Bootstraps an `etcd` cluster on your `kubernetes-controller` nodes
  - Bootstraps a HA Kubernetes Control Plane on your `kubernetes-controller` nodes
  - Bootstraps your `kubernetes-worker` nodes

```
scripts/kubernetes.sh
```

**Verification**

kubernetes-controller nodes:

- Ensure that these files exist in the home directory:
  - `ca.pem`
  - `kubernetes-key.pem`
  - `kubernetes.pem`
- Ensure that these files exist in `/etc/etcd`:
  - `ca.pem`
  - `kubernetes-key.pem`
  - `kubernetes.pem`
- Ensure that these files exist in `/var/lib/kubernetes`:
  - `ca.pem`
  - `kubernetes-key.pem`
  - `kubernetes.pem`
  - `token.csv`
  - `authorization-policy.jsonl`  
- Ensure that these binaries exist in `/usr/bin`:
  - `etcd`
  - `etcdctl`
  - `kube-apiserver`
  - `kube-controller-manager`
  - `kube-scheduler`
  - `kubectl`
- Ensure that the following services exist in `/etc/systemd/system`:
  - `etcd.service`
  - `kube-apiserver.service`
  - `kube-controller-manager.service`
  - `kube-scheduler.service`
- Verify the status of the following services:
  - `sudo systemctl status etcd --no-pager`
  - `sudo systemctl status kube-apiserver --no-pager`
  - `sudo systemctl status kube-controller-manager --no-pager`
  - `sudo systemctl status kube-scheduler --no-pager`
- Verify the status of the `etcd` cluster:
  - `etcdctl --ca-file=/etc/etcd/ca.pem cluster-health`
- Verify the status of all Kubernetes components:
  - `kubectl get componentstatuses`

kubernetes-worker nodes:

- Ensure that these files exist in the home directory:
  - `ca.pem`
  - `kubernetes-key.pem`
  - `kubernetes.pem`
- Ensure that these files exist in `/var/lib/kubernetes`:
  - `ca.pem`
  - `kubernetes-key.pem`
  - `kubernetes.pem`
- Ensure that docker is installed properly:
  - `sudo docker version`
- Ensure that the following file exists in `/var/lib/kubelet`:
  - `kubeconfig`
- Ensure that the following services exist in `/etc/systemd/system`:
  - `docker.service`
  - `kubelet.service`
  - `kube-proxy.service`
- Verify the status of the following services:
  - `sudo systemctl status docker --no-pager`
  - `sudo systemctl status kubelet --no-pager`
  - `sudo systemctl status kube-proxy --no-pager`
- Verify that the `hosts` file in `/etc` contains an assignment between the private IP of the node and its short private DNS

#### Configuring remote access

```
scripts/remote.sh
```

**Verification**

Run the following commands on your local machine:

```
kubectl get componentstatuses
kubectl get nodes
```

#### Setting up container network routes

```
scripts/route.sh
```

**Verification**

Ensure that the newly added 3 routes exist within the route table in AWS:
```
aws ec2 describe-route-tables --filter "Name=tag:Name,Values=nk-route-table-igw"
```

#### Deploying the Cluster DNS Add-on

```
scripts/dns.sh
```

**Verification**

Run the following commands on your local machine:

```
kubectl --namespace=kube-system get svc
kubectl --namespace=kube-system get pods
```

### Testing the infrastructure

Run the following script and check whether the deployed nginx server responds properly:
```
scripts/smoke.sh
```

### Deprovisioning the infrastructure

```
terraform destroy
```
