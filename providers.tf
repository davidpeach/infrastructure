###########################################################
# Apis that Terraform will use to set up my Infrastructure.
###########################################################

provider "digitalocean" {
    token = var.do_token
}

provider "github" {
    token = var.github_token
}
