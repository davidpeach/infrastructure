###########################################################
# Apis that Terraform will use to set up my Infrastructure.
###########################################################

provider "digitalocean" {
    token = var.do_token
    spaces_access_id  = var.spaces_access_id
    spaces_secret_key = var.spaces_secret_key
}

provider "github" {
    token = var.github_token
}
