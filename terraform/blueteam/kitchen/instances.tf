resource "openstack_blockstorage_volume_v3" "team_volumes" { // create volumes for each host
  for_each = var.hosts

  name = format("%s.blueteam.%s-volume", each.key, var.competition_domain)
  size        = each.value.size
  image_id    = each.value.image

  timeouts {
    create = "30m"
  }
}

resource "openstack_compute_instance_v2" "team_kitchen_instance" {
    depends_on = [ openstack_networking_subnet_v2.blueteam_kitchen_subnet ]
    for_each = var.hosts
    name = format("%s.blueteam.%s", each.key, var.competition_domain)
    flavor_id = each.value.flavor 
    tags = setunion(var.inherited_tags,  // comp name
                    [format("project-${var.competition_name}-blueteam")], // project name
                    ["kitchen"], // Network Location
                    [format("blueteam-${each.key}")] //hostname
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

    user_data = lookup(each.value, "user_data", null) // assign user data, if it exists
}