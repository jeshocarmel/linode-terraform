output "node_balancer_ip_hostname" {
  value       = linode_nodebalancer.lb.hostname
}

output "node_balancer_ip" {
  value       = linode_nodebalancer.lb.ipv4
}
