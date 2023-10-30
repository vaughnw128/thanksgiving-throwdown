/**

Management instances

**/

resource "openstack_blockstorage_volume_v3" "management_volumes" {
  for_each = var.hosts

  name = format("%s.management.%s-volume", each.key, var.competition_domain)
  size        = each.value.size
  image_id    = each.value.image

  timeouts {
    create = "30m"
  }
}

/**

Management instances

**/

resource "openstack_compute_instance_v2" "management_instance" {
    for_each = var.hosts
    name = "${each.key}.management.${var.competition_domain}"
    depends_on = [ openstack_networking_subnet_v2.management_subnet ]
    flavor_id = each.value.flavor
    tags = setunion(var.inherited_tags,
                    [format("project-${var.competition_name}-mgmt")],
                    [format("mgmt-${each.key}")],
                    )
    security_groups = [
        "default",
        local.secgroups[each.value.secgroup],
    ]
    block_device {
        uuid = openstack_blockstorage_volume_v3.management_volumes[each.key].id
        volume_size = openstack_blockstorage_volume_v3.management_volumes[each.key].size
        boot_index = 0
        delete_on_termination = true
        source_type = "volume"
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