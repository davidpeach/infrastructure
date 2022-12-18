########################################################################################################
# These are all of the resources I am creating in my Infrastructure with Terraform.
# There are some items that exist already (like my vpc_network) which is accessing in the  data.tf file.
# It's completely over-engineered for what I need, but I just wanted to learn it. :D
########################################################################################################

resource "digitalocean_kubernetes_cluster" "kubernetes_cluster" {
    name   = var.kubernetes_cluster_name
    region = "lon1"
    # Grab the latest version slug from `doctl kubernetes options versions`
    version = var.kubernetes_cluster_version

    node_pool {
        name       = var.node_pool_name
        size       = var.node_pool_node_type
        node_count = var.node_pool_count
    }
}

resource "digitalocean_container_registry" "registry" {
    name                   = var.registry_name
    subscription_tier_slug = "starter"
    region                  = "ams3"
}

resource "digitalocean_database_cluster" "database_cluster" {
    name       = var.mysql_database_cluster_name
    engine     = "mysql"

    # Grab the latest version number with `doctl databases options versions`
    version    = "8"
    size       = var.mysql_database_cluster_size
    region     = "lon1"
    node_count = 1
    private_network_uuid = data.digitalocean_vpc.vpc_network.id
}

resource "digitalocean_database_db" "davidpeachcouk_mysql_database" {
    cluster_id = digitalocean_database_cluster.database_cluster.id
    name       = var.davidpeachcouk_mysql_database_name
}

resource "digitalocean_spaces_bucket" "davidpeachcouk_spaces_bucket" {
    name   = var.davidpeachcouk_spaces_bucket_name
    region = "ams3"
    acl    = "public-read"

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET"]
        allowed_origins = ["*"]
        max_age_seconds = 3000
    }

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT", "POST", "DELETE"]
        allowed_origins = [var.davidpeachcouk_fully_qualified_domain]
        max_age_seconds = 3000
    }
}

resource "digitalocean_certificate" "cert" {
    name    = "spaces-cdn-cert"
    type    = "lets_encrypt"
    domains = [var.davidpeachcouk_spaces_fully_qualified_domain]
}

resource "digitalocean_cdn" "mycdn" {
    origin           = digitalocean_spaces_bucket.davidpeachcouk_spaces_bucket.bucket_domain_name
    custom_domain    = var.davidpeachcouk_spaces_fully_qualified_domain
    certificate_name = digitalocean_certificate.cert.name
}

resource "github_actions_secret" "registry_endpoint_secret" {
    repository       = var.davidpeachcouk_github_repository_name
    secret_name      = "DO_REGISTRY_ENDPOINT"
    plaintext_value  = digitalocean_container_registry.registry.endpoint
}

resource "github_actions_secret" "do_access_token_secret" {
    repository       = var.davidpeachcouk_github_repository_name
    secret_name      = "DO_ACCESS_TOKEN"
    plaintext_value  = var.do_token
}

resource "github_actions_secret" "laravel_env_encryption_key_secret" {
    repository       = var.davidpeachcouk_github_repository_name
    secret_name      = "LARAVEL_ENV_ENCRYPTION_KEY"
    plaintext_value  = var.davidpeachcouk_laravel_encryption_secret
}

