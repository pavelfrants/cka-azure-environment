output "control-plane-node-pip" {
  value = module.control-plane-node.public_ip_dns_name
}

output "worker-node-pip" {
  value = module.worker-node.public_ip_dns_name
}