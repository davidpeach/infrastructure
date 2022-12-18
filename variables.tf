#########################################
# These are all of the variables that are required to be 
# set for the configuration to run succesfully.
#
# Ways to set them:
# -- In the terraform.tfvars file (for non-sensitive values)
# -- Pass as cli argument e.g. -var="do_token=my-secret-token-here"
# -- As an env variable, prefixed with "TF_VAR_", like: TF_VAR_do_token="my-secret-token-here"
########################################

variable "do_token" {
    sensitive = true
}

variable "spaces_access_id" {
    sensitive = true
}

variable "spaces_secret_key" {
    sensitive = true
}

variable "github_token" {
    sensitive = true
}

variable "davidpeachcouk_laravel_encryption_secret" {
    sensitive = true
}

# Specifics to my personal website.
# I may have other domains in my cluster, requiring extra variables.
variable "davidpeachcouk_fully_qualified_domain" {}
variable "davidpeachcouk_github_repository_name" {}
variable "davidpeachcouk_mysql_database_name" {}
variable "davidpeachcouk_spaces_bucket_name" {}
variable "davidpeachcouk_spaces_fully_qualified_domain" {}

# The container registry I want
variable "registry_name" {}

# MySQL database cluster used by all.
# Each database will be created for each of my sites that require one.
variable "mysql_database_cluster_name" {}
variable "mysql_database_cluster_size" {}

# The Kubernetes Cluster.
variable "kubernetes_cluster_name" {}
variable "kubernetes_cluster_version" {}

# Kubernetes node configuration.
variable "node_pool_name" {}
variable "node_pool_node_type" {}
variable "node_pool_count" {}

