/**

Volumes

**/

// Normal instances
resource "openstack_blockstorage_volume_v3" "team_volumes" {
    for_each = var.hosts

    name = format("%s.blueteam.%s-volume", each.key, var.competition_domain)
    size        = each.value.size
    image_id    = each.value.image

    timeouts {
      create = "30m"
    }
}

// Jumpbox
resource "openstack_blockstorage_volume_v3" "jumpbox_volume" {
    name = format("%s.blueteam.%s-volume", var.jumpbox.hostname, var.competition_domain)
    size        = var.jumpbox.size
    image_id    = var.jumpbox.image
    
    timeouts {
      create = "30m"
    }
}

/**

Instances

**/

// Normal instances
resource "openstack_compute_instance_v2" "team_homelab_instance" {
    depends_on = [ openstack_networking_subnet_v2.blueteam_homelab_subnet ]
    for_each = var.hosts
    name = format("%s.blueteam.%s", each.key, var.competition_domain)
    flavor_id = each.value.flavor 
    tags = setunion(var.inherited_tags,
                    [format("project-${var.competition_name}-blueteam")], 
                    ["homelab"],
                    [format("blueteam-${each.key}")]
                    )

    block_device {
        uuid = openstack_blockstorage_volume_v3.team_volumes[each.key].id
        volume_size = openstack_blockstorage_volume_v3.team_volumes[each.key].size
        boot_index = 0
        delete_on_termination = true
        source_type = "volume"
        destination_type = "volume"
    }

    network {
       port = local.ports[each.value.port]
    }

    user_data = lookup(each.value, "user_data", null)
}

// Jumpbox
resource "openstack_compute_instance_v2" "team_jumpbox_instance" {
    depends_on = [ openstack_networking_subnet_v2.blueteam_homelab_subnet ]
    name = format("%s.blueteam.%s", var.jumpbox.hostname, var.competition_domain)
    flavor_id = var.jumpbox.flavor 
    tags = setunion(var.inherited_tags, 
                    [format("project-${var.competition_name}-blueteam")],
                    ["homelab"],
                    ["jumpbox"] 
                    )

    block_device {
        uuid = openstack_blockstorage_volume_v3.jumpbox_volume.id
        volume_size = openstack_blockstorage_volume_v3.jumpbox_volume.size
        boot_index = 0
        delete_on_termination = true
        source_type = "volume"
        destination_type = "volume"
    }

    network {
        port = local.ports[var.jumpbox.homelab_port]
    }
     network {
        port = local.ports[var.jumpbox.management_port]
    }

    user_data = lookup(var.jumpbox, "user_data", null)
}
