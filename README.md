# Deploying a stateful, clustered, HA service on AWS

## Prerequisites

- Locally installed terraform (https://www.terraform.io/downloads.html)
- Locally installed Ansible (http://docs.ansible.com/ansible/intro_installation.html)
- Locally installed Python
  - AWS SDK for Python (https://aws.amazon.com/sdk-for-python/)

## Provisioning the infrastructure

#### Generate Key Pair for accessing EC2 instances

```
ssh-keygen -t rsa -C "leapforward" -P '' -f ~/.ssh/leapforward
ssh-add ~/.ssh/leapforward
```

#### Provide values for predefined variables through `terraform.tfvars`

```
touch terraform.tfvars
```

Set the required variables
  - access_key
  - secret_key
  - ssh_key_name
  - my_cidr

#### Applying the infrastructure changes

```
terraform apply
```

#### Getting useful IP and DNS addresses from terrafrom

```
terraform output elb_dns
terraform output ovpn_public_ip
terraform output etcd_private_ips
```

#### Accessing the EC2 instances through SSH once the infrastructure is provisioned

OVPN box:

Can be accessed via its public DNS / IP

```
ssh ubuntu@hostname
ssh ubuntu@$(terraform output ovpn_public_ip)
```

etcd boxes:

Can be accessed via their private IPs with SSH forwarding from the local machine through the OVPN box

```
ssh -A ubuntu@hostname
ssh -A ubuntu@$(terraform output ovpn_public_ip)

ssh centos@[Private IP of etcd box]
```

Can be accessed via their private IPs if connected to the VPN

```
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no centos@[Private IP of etcd box]
```
OR without extra properties by removing the offending line from the `known_hosts` file
```
sed -i '' [offending line number]d ~/.ssh/known_hosts
ssh centos@[Private IP of etcd box]
```

## Running Ansible

### OVPN box

```
cd ansible_vpn
./vpn.sh
```

Once the the script has finished and the leapforward.vpn.zip archive is downloaded to the ansible_vpn directory, you can extract it and using the credential and your favourite OVPN client you can connect to the VPN

### etcd boxes

Prerequisite: Active VPN connection to the OVPN box

```
cd ansible_etcd
./etcd.sh
```

## Testing the infrastructure and the etcd cluster

Prerequisite: Active VPN connection to the VPC

```
curl -L http://$(terraform output elb_dns):2379/version
curl -L http://$(terraform output elb_dns):2379/health
curl http://$(terraform output elb_dns):2379/v2/keys/hello -XPUT -d value="world"
curl http://$(terraform output elb_dns):2379/v2/keys/hello
```

## Deprovisioning the infrastructure

```
terraform destroy
```
