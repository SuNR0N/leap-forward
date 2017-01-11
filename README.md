# leap-forward

## Generate Key Pair for accessing EC2 instances

```
ssh-keygen -t rsa -C "leapforward" -P '' -f ~/.ssh/leapforward
```

## Provide values for predefined variables through `terraform.tfvars`

```
touch terraform.tfvars
```

Set the required variables
  - access_key
  - secret_key
  - ssh_key_name
  - my_cidr

## Provisioning the infrastructure

```
terraform apply
```

## Accessing the EC2 instances through SSH once the infrastructure is provisioned

```
ssh -i ~/.ssh/leapforward centos@hostname
```

## Deprovisioning the infrastructure

```
terraform destroy
```
