terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.14.3"
    }
  }
}

resource "linode_sshkey" "mykey" {
  label = "My SSH key"
  ssh_key = chomp(file(var.public_key_location))
}

resource "linode_instance" "web" {
    count  = var.node_count
    label = "web_server-${count.index}"
    image = "linode/ubuntu18.04"
    region = var.region
    type = var.instance_type
    authorized_keys = [linode_sshkey.mykey.ssh_key]
    root_pass = var.root_password

    group = "web-servers"
    tags = [ "demo" ]
    private_ip = true


    connection {
      type     = "ssh"
      user     = "root"
      password = var.root_password
      host     = self.ip_address
    }

    provisioner "file" {
      source      = "setup_script.sh"
      destination = "/tmp/setup_script.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/setup_script.sh",
        "/tmp/setup_script.sh",
      ]
    }
}