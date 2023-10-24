resource "openstack_blockstorage_volume_v3" "redteam_volumes" { // create volumes for each host
  for_each = var.redteam_hosts

  name = format("%s.redteam.%s-volume", each.key, var.competition_domain)
  size        = each.value.size
  image_id    = each.value.image

  timeouts {
    create = "30m"
  }
}

resource "openstack_blockstorage_volume_v3" "jumpbox_volume" { // create volume for jumpbox
    name = format("%s.redteam.%s-volume", var.jumpbox.hostname, var.competition_domain)
    size        = var.jumpbox.size
    image_id    = var.jumpbox.image
    
    timeouts {
      create = "30m"
    }
}

resource "openstack_compute_instance_v2" "redteam_instance" {
    /*
    In this instances block, we take everything that we specified in the management/main.tf file, 
    and turn them into the attribuates on the stack

    We could probably assign tags 
    */
    for_each = var.redteam_hosts // we define a list like structure to iterate through the private hosts
    name = "${each.key}.redteam.${var.competition_domain}"
    depends_on = [ openstack_networking_subnet_v2.redteam_subnet ]
    flavor_id = each.value.flavor // assign flavors
    tags = setunion(var.inherited_tags,  // comp name
                    [format("project-${var.competition_name}-mgmt")], // project name
                    [format("redteam-${each.key}")],
                    )
    block_device { // assign image attributes
        uuid = openstack_blockstorage_volume_v3.redteam_volumes[each.key].id // the volume id
        boot_index = 0 // the disk size
        delete_on_termination = true
        source_type = "volume"
        destination_type = "volume"
    }
    network {
        port = local.ports[each.value.redteam_port] // assign the port
    } 

    user_data = lookup(each.value, "user_data", null)
    config_drive = true
    
}

// Jumpbox
resource "openstack_compute_instance_v2" "team_jumpbox_instance" {
    depends_on = [ openstack_networking_subnet_v2.redteam_subnet ]
    name = format("%s.redteam.%s", var.jumpbox.hostname, var.competition_domain)
    flavor_id = var.jumpbox.flavor //jumpbox flavor
    tags = setunion(var.inherited_tags,  // comp name
                    [format("project-${var.competition_name}-redteam")], // project name
                    ["redteam"], // Network Location
                    ["jumpbox"] //hostname
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
        port = local.ports[var.jumpbox.redteam_port]
    }
     network {
        port = local.ports[var.jumpbox.management_port]
    }   
}

