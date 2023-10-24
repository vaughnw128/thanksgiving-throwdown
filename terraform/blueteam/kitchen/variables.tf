variable "tenant_name" {
    description = "project name"
    type = string
}
variable "competition_name" {
    description = "Name of the competition (e.g. ISTS)"
    type = string
}

variable "competition_domain" {
    description = "Domain for the competition"
    type = string
}

// For VMs
variable "hosts" {
    description = "Map of VM details hostname:vars"
    type = map
}

// tags
variable "inherited_tags" {
    description = "Tags for Instances"
    type = set(string)
}