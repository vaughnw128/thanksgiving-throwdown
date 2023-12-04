// Globals
variable "project_name" {
    description = "Project name for everything"
    type = string
}

variable "project_id" {
    description = "Openstack project ID"
    type = string
}

variable "username" {
    description = "Openstack username"
    type = string
}

variable "password" {
    description = "Openstack password"
    type = string
}

variable "auth_url" {
    description = "Openstack authentication url"
    type = string
}

variable "competition_name" {
    description = "Name of the competition"
    type = string
}

variable "competition_domain" {
    description = "Domain for the competition"
    type = string
}

//tags
variable "inherited_tags" {
    description = "Tags for Instances"
    type = set(string)
}