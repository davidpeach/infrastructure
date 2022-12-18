#####################################################################
# Outputs can be accessed after a terraform apply has been ran.
# I use this to give me back the database details I need to put in my 
# production env.
#####################################################################

output "db_user" {
    value = "${digitalocean_database_cluster.database_cluster.user}"
    sensitive = true
}

output "db_password" {
    value = "${digitalocean_database_cluster.database_cluster.password}"
    sensitive = true
}

output "db_host" {
    value = "${digitalocean_database_cluster.database_cluster.host}"
    sensitive = true
}

output "db_port" {
    value = "${digitalocean_database_cluster.database_cluster.port}"
    sensitive = true
}

