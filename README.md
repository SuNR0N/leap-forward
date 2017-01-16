# leap-forward

## Prerequisites

- Locally installed terraform (https://www.terraform.io/downloads.html)
- Locally installed Ansible (http://docs.ansible.com/ansible/intro_installation.html)
- Locally installed Python (v3)
  - AWS SDK for Python (https://aws.amazon.com/sdk-for-python/)

### Generate Key Pair for accessing EC2 instances

```
ssh-keygen -t rsa -C "leapforward" -P '' -f ~/.ssh/leapforward
ssh-add ~/.ssh/leapforward
```

### Provide values for predefined variables through `terraform.tfvars`

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

### Accessing the EC2 instances through SSH once the infrastructure is provisioned

OVPN box (can be accessed via its public DNS / IP):
```
ssh centos@hostname
```

etcd boxes (can be accessed via their private IPs):
```
ssh -A ubuntu@hostname
ssh centos@[Private IP of etcd box]
```

### Running the Ansible playbook for the OVPN box

```
cd ansible_vpn
./vpn.sh
```

Once the the script has finished and the leapforward.vpn.zip archive is downloaded to the ansible_vpn directory, you can extract it and using the credential and your favourite OVPN client you can connect to the VPN

### Running the Ansible playbook for the etcd boxes

Prerequisite: Active VPN connection to the OVPN box

```
cd ansible_etcd
./etcd.sh
```

### Testing the infrastructure and the etcd cluster

Prerequisite: Active VPN connection to the VPC

```
curl -L http://<etcd-ELB-dns-name>:2379/version
curl -L http://<etcd-ELB-dns-name>:2379/health
curl http://<etcd-ELB-dns-name>:2379/v2/keys/hello -XPUT -d value="world"
curl http://<etcd-ELB-dns-name>:2379/v2/keys/hello
```

### Deprovisioning the infrastructure

```
terraform destroy
```
