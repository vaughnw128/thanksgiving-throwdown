// Meta
variable "project_id" {
    description = "Parent project id for the whole competition"
    type = string
}

variable "competition_domain" {
    description = "Domain for whole competition"
    type = string
}



variable "competition_name" {
    description = "The name of the competition"
    type = string
}

variable "external_network" {
    description = "External Network UUID"
}

// tags
variable "inherited_tags" {
    description = "Tags for Instances"
    type = set(string)
}

variable "tenant_name" {
    description = "project name"
    type = string
}

variable "redteam_hosts" {
    description = "Map of management VM details hostname:vars"
    type = map
}

variable "jumpbox" {
    description = "Jumpbox details"
    type = map
}

