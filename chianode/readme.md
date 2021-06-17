# Chia Node

This module is intended to deploy a generic Chia-Blockchain installation and should support running most, if not all, of the services we might want to run (node, introducer, farmer, etc). By default, also deploys a load balancer, but this can be disabled for standalone nodes.

## Required Vars

- `vpc_id` ID of the VPC to deploy to
- `subnet_id` Subnet to deploy to in the VPC
- `key_name` SSH key to add to the instances
- `application_tag` - The application - chia-blockchain, faucet, etc
- `component_tag` - The component of the application - dns-introducer, fullnode, farmer, etc
- `network_tag` - Network - mainnet, testnet, etc

## Provisioning

Once the node is up, provisioning is done with Ansible. Ansible roles are available in the [ansible-roles repo](https://github.com/Chia-Network/ansible-roles)
