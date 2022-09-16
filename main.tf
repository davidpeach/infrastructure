terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_vpc" "peach-network" {
  name   = "peach-network"
  region = "lon1"
}

resource "digitalocean_database_cluster" "peach-mysql-cluster" {
  name       = "peach-mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "lon1"
  node_count = 1
  private_network_uuid = digitalocean_vpc.peach-network.id
}

resource "digitalocean_spaces_bucket" "peach-spaces-bucket" {
  name   = "peach-spaces-bucket"
  region = "ams3"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
    allowed_origins = ["https://davidpeach.me"]
    max_age_seconds = 3000
  }
}
