resource "openstack_compute_instance_v2" "private_instance" {
    for_each = var.private_hosts // we define a list like structure to iterate through the private hosts
    name = "${each.key}.management.${var.competition_domain}"
    depends_on = [ openstack_networking_subnet_v2.management_subnet ]
    flavor_id = each.value.flavor // assign flavors
    tags = setunion(var.inherited_tags,  // comp name
                    [format("project-${var.competition_name}-mgmt")], // project name
                    [format("mgmt-${each.key}")],
                    )
    block_device { // assign image attributes
        uuid = each.value.image // the actual image
        boot_index = 0 // the disk size
        volume_size = each.value.size
        delete_on_termination = true
        source_type = "image"
        destination_type = "volume"
    }
    network {
        port = local.ports[each.value.mgmt_port]
    } 

    timeouts {
        create = "10m"
        delete = "10m"
    }

    user_data = lookup(each.value, "user_data", null)
    config_drive = true
}

resource "openstack_compute_instance_v2" "public_instance" {
    for_each = var.public_hosts // we define a list like structure to iterate through the private hosts
    name = "${each.key}.management.${var.competition_domain}"
    depends_on = [ openstack_networking_subnet_v2.management_subnet ]
    flavor_id = each.value.flavor // assign flavors
    tags = setunion(var.inherited_tags,  // comp name
                    [format("project-${var.competition_name}-mgmt")], // project name
                    [format("mgmt-${each.key}")],
                    )
    security_groups = [ // assign security groups
        "default",
        local.secgroups[each.value.secgroup],
    ]
    block_device { // assign image attributes
        uuid = each.value.image // the actual image
        boot_index = 0 // the disk size
        volume_size = each.value.size
        delete_on_termination = true
        source_type = "image"
        destination_type = "volume"
    }
    network {
        port = local.ports[each.value.mgmt_port]
    }

    timeouts {
        create = "10m"
        delete = "10m"
    }

    user_data = lookup(each.value, "user_data", null)
    config_drive = true
}