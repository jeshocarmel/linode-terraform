terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.14.3"
    }
  }

/*
  // https://adriano.fyi/post/2020-05-29-how-to-use-linode-object-storage-as-a-terraform-backend/ 

  backend "s3" {
    bucket = "test-bucket-jesh"
    key    = "state.tfstate"
    region = "ap-south-1"                      # e.g. us-east-1
    endpoint = "ap-south-1.linodeobjects.com"    # e.g. us-est-1.linodeobjects.com
    skip_credentials_validation = true                # just do it
    access_key = ""
    secret_key = ""
  }
  */
}

provider "linode" {
  token = var.api_token
}

module "myapp-server" {
    source = "./modules/webserver"
    public_key_location = var.public_key_location
    root_password = var.root_password
    region = var.region
    node_count = var.node_count
    instance_type = var.instance_type
}

# node balancer configuration

module "myapp-lb" {
  source = "./modules/nodebalancer"
  region = var.region
  node_count = var.node_count
  web_server_ips = module.myapp-server.web_servers_ips
}