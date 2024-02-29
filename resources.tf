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
