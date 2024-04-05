output "sg_testnet_fullnode_id" {
    value = aws_security_group.testnet-full-node.id
    description = "Chia Testnet Full Node security group"
}

output "sg_mainnet_fullnode_id" {
    value = aws_security_group.mainnet-full-node.id
    description = "Chia Mainnet Full Node security group"
}

output "sg_allow_outbound_id" {
    value = aws_security_group.allow-all-outbound.id
    description = "Allow all outbound connections security group"
}

output "core_registry_key_pair" {
    value   = aws_key_pair.core-registry-keypair.key_name
    description = "Key pair with no access"
}
