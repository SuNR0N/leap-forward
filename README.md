# leap-forward

1. ssh-keygen -t rsa -C "leapforward" -P '' -f ~/.ssh/leapforward
2. touch terraform.tfvars
  - Set the required variables
    - access_key
    - secret_key
    - ssh_key_name
    - my_cidr
3. terraform apply
