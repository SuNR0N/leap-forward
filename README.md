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

```
ssh centos@hostname
```

### Running the Ansible playbook

```
cd ansible
./playbook.sh
```

### Deprovisioning the infrastructure

```
terraform destroy
```
