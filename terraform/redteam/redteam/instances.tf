/**

Redteam volumes

**/

// Normal instances
resource "openstack_blockstorage_volume_v3" "redteam_volumes" { // create volumes for each host
  for_each = var.redteam_hosts

  name = format("%s.redteam.%s-volume", each.key, var.competition_domain)
  size        = each.value.size
  image_id    = each.value.image

  timeouts {
    create = "30m"
  }
}

/**

Redteam instances

**/

// Normal instances
resource "openstack_compute_instance_v2" "redteam_instance" {
    for_each = var.redteam_hosts
    name = "${each.key}.redteam.${var.competition_domain}"
    depends_on = [ openstack_networking_subnet_v2.redteam_subnet ]
    flavor_id = each.value.flavor
    tags = setunion(var.inherited_tags,
                    [format("project-${var.competition_name}-mgmt")],
                    [format("redteam-${each.key}")],
                    )
    block_device {
        uuid = openstack_blockstorage_volume_v3.redteam_volumes[each.key].id
        boot_index = 0 
        delete_on_termination = true
        source_type = "volume"
        destination_type = "volume"
    }
    network {
        port = local.ports[each.value.redteam_port]
    } 

    user_data = lookup(each.value, "user_data", null)
    config_drive = true
    
}

