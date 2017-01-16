# Ansible code for installing OpenVPN server

(might not be production-ready)

## Things to change

Edit the playbook `vpn.yaml` changing `cidr_vpc` and `internal_dns_zone` variables.

The playbook targets a host named `ovpn-node` which is identified by a given `Type` tag. The inventory extracts the content of the `Name` tag as host.

The Inventory returns only instances tagged `Owner`= `Norbert`. Change `instance_filters = tag:Owner=Norbert` in `ec2.ini` to match your tag.

Edit `ansible.cfg` if required.

## Usage

The playbook install the OpenVPN server, generates and download the OpenVPN client configuration in the playbook directory, in a zip named `leapforward.vpn.zip`.

Unzip the configuration and install it in your preferred OpenVPN client.
