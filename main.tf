terraform {
  cloud {
    organization = "davidpeach"

    workspaces {
      name = "redemption"
    }
  }
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {
    sensitive = true
}
variable "github_token" {
    sensitive = true
}
variable "fully_qualified_domain" {}
variable "github_repository_name" {}
variable "registry_name" {}
variable "database_cluster_name" {}
variable "database_name" {}
variable "kubernetes_cluster_name" {}
variable "node_pool_name" {}
variable "spaces_bucket_name" {}

provider "digitalocean" {
  token = var.do_token
}

provider "github" {
    token = var.github_token
}

resource "digitalocean_vpc" "vpc_network" {
  name   = var.fully_qualified_domain
  region = "lon1"
}

resource "digitalocean_container_registry" "registry" {
  name                   = var.registry_name
  subscription_tier_slug = "starter"
  region                  = "ams3"
}

resource "digitalocean_database_db" "database" {
  cluster_id = digitalocean_database_cluster.database_cluster.id
  name       = var.database_name
}

resource "digitalocean_database_cluster" "database_cluster" {
  name       = var.database_cluster_name
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "lon1"
  node_count = 1
  private_network_uuid = digitalocean_vpc.vpc_network.id
}

resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
  name   = var.kubernetes_cluster_name
  region = "lon1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = var.node_pool_name
    size       = "s-1vcpu-2gb"
    node_count = 2
  }
}

resource "github_actions_secret" "registry_endpoint_secret" {
  repository       = var.github_repository_name
  secret_name      = "DO_REGISTRY_ENDPOINT"
  plaintext_value  = digitalocean_container_registry.registry.endpoint
}

# Create a github action secret for repos for the DO Token.
resource "github_actions_secret" "do_access_token_secret" {
  repository       = var.github_repository_name
  secret_name      = "DO_ACCESS_TOKEN"
  plaintext_value  = var.do_token
}

resource "github_actions_secret" "laravel_env_encryption_key_secret" {
  repository       = var.github_repository_name
  secret_name      = "LARAVEL_ENV_ENCRYPTION_KEY"
  plaintext_value  = "3UVsEgGVK36XN82KKeyLFMhvosbZN1aF"
}

resource "digitalocean_spaces_bucket" "bucket" {
  name   = var.spaces_bucket_name
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
    allowed_origins = [var.fully_qualified_domain]
    max_age_seconds = 3000
  }
}
