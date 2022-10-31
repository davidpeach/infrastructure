terraform {
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
variable "do_token" {}
variable "github_token" {}

provider "digitalocean" {
  token = var.do_token
}

provider "github" {
    token = var.github_token
}

resource "digitalocean_vpc" "davidpeach-me-network" {
  name   = "davidpeach.me"
  region = "lon1"
}

resource "digitalocean_container_registry" "newhanover-registry" {
  name                   = "rhodes"
  subscription_tier_slug = "starter"
  region                  = "ams3"
}

resource "digitalocean_database_db" "newhanover-mysql-davidpeach-me" {
  cluster_id = digitalocean_database_cluster.newhanover-mysql-cluster.id
  name       = "davidpeachme"
}

resource "digitalocean_database_cluster" "newhanover-mysql-cluster" {
  name       = "newhanover-mysql-cluster"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "lon1"
  node_count = 1
  private_network_uuid = digitalocean_vpc.davidpeach-me-network.id
}

resource "digitalocean_kubernetes_cluster" "newhanover-k8s-cluster" {
  name   = "newhanover"
  region = "lon1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.24.4-do.0"

  node_pool {
    name       = "valentine"
    size       = "s-1vcpu-2gb"
    node_count = 3
  }
}

resource "github_actions_secret" "registry_endpoint_secret" {
  repository       = "laravel-app-k8s"
  secret_name      = "DO_REGISTRY_ENDPOINT"
  plaintext_value  = digitalocean_container_registry.newhanover-registry.endpoint
}

# Create a github action secret for repos for the DO Token.
resource "github_actions_secret" "do_access_token_secret" {
  repository       = "laravel-app-k8s"
  secret_name      = "DO_ACCESS_TOKEN"
  plaintext_value  = var.do_token
}

/* resource "digitalocean_spaces_bucket" "peach-spaces-bucket" { */
/*   name   = "peach-spaces-bucket" */
/*   region = "ams3" */

/*   cors_rule { */
/*     allowed_headers = ["*"] */
/*     allowed_methods = ["GET"] */
/*     allowed_origins = ["*"] */
/*     max_age_seconds = 3000 */
/*   } */

/*   cors_rule { */
/*     allowed_headers = ["*"] */
/*     allowed_methods = ["PUT", "POST", "DELETE"] */
/*     allowed_origins = ["https://davidpeach.me"] */
/*     max_age_seconds = 3000 */
/*   } */
/* } */
