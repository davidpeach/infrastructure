#########################################################################
# Any infrastructure items that already exist in my Digital Ocean account
# can be accessed with "data" blocks like this.
# It can then be used when creating other resources.
#########################################################################

data "digitalocean_vpc" "vpc_network" {
    name = "davidpeach.co.uk"
}
