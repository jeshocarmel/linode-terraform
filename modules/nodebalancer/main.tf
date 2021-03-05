terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.14.3"
    }
  }
}

resource "linode_nodebalancer" "lb" {
    label = "mynodebalancer"
    region = var.region
    client_conn_throttle = 20
    tags = ["demo"]
}

resource "linode_nodebalancer_config" "lb-config" {
    nodebalancer_id = linode_nodebalancer.lb.id
    port = 80
    protocol = "http"
    check = "http"
    check_path = "/"
    check_attempts = 3
    check_timeout = 3
    check_interval = 5
    stickiness = "http_cookie"
    algorithm = "roundrobin"
}

resource "linode_nodebalancer_node" "webnode" {
    count = var.node_count
    nodebalancer_id = linode_nodebalancer.lb.id
    config_id = linode_nodebalancer_config.lb-config.id
    address = "${element(var.web_server_ips, count.index)}:8080"
    label = "nb-backnode-${count.index}"
    weight = 100
}
