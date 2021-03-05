output "web_servers_ips" {
  value = linode_instance.web.*.private_ip_address
}