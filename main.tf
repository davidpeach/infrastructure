#############################################################################################################
# This is the initial Terraform entry point.
# Here I tell terraform that I will be using "cloud", for my terraform state file.
# I also tell it that I require digitalocean and github providers. The setup of those is done in providers.tf
#############################################################################################################

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

