/**

Network ports for jumpbox

Connects from management to homelab

**/

# resource "openstack_networking_port_v2" "jumpbox_management_port"{
#     name = "Blueteam Jumpbox Management"
#     network_id = data.openstack_networking_network_v2.management_network.id
#     fixed_ip {
#         subnet_id = data.openstack_networking_subnet_v2.management_subnet.id
#         ip_address = "10.100.0.100"
#     }
#     security_group_ids = [
#         local.secgroups["default"],
#         local.secgroups["jumpbox"]
#     ]
# }

# resource "openstack_networking_port_v2" "jumpbox_homelab_port"{
#     name = "Blueteam Jumpbox Homelab"
#     network_id = openstack_networking_network_v2.blueteam_homelab.id
#     fixed_ip {
#         subnet_id = openstack_networking_subnet_v2.blueteam_homelab_subnet.id
#         ip_address = "10.1.0.100"
#     }
#     security_group_ids = [
#         local.secgroups["default"],
#         local.secgroups["jumpbox"]
#     ]
# }

/**

Network ports with static IPs for homelab devices

**/

resource "openstack_networking_port_v2" "dc_port"{
    name = "Blueteam Homelab Domain Controller"
    network_id = openstack_networking_network_v2.blueteam_homelab.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_homelab_subnet.id
        ip_address = "10.1.0.1"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["homelab"]
    ]
}

resource "openstack_networking_port_v2" "pc_port"{
    name = "Blueteam Homelab Personal Computer"
    network_id = openstack_networking_network_v2.blueteam_homelab.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_homelab_subnet.id
        ip_address = "10.1.0.2"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["homelab"]
    ]
}

resource "openstack_networking_port_v2" "media_port"{
    name = "Blueteam Homelab Media"
    network_id = openstack_networking_network_v2.blueteam_homelab.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_homelab_subnet.id
        ip_address = "10.1.0.3"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["homelab"]
    ]
}

resource "openstack_networking_port_v2" "pihole_port"{
    name = "Blueteam Homelab Pihole"
    network_id = openstack_networking_network_v2.blueteam_homelab.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_homelab_subnet.id
        ip_address = "10.1.0.4"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["homelab"]
    ]
}

locals {
    ports = {
        "media": openstack_networking_port_v2.media_port.id
        "dc": openstack_networking_port_v2.dc_port.id
        "pc": openstack_networking_port_v2.pc_port.id
        "pihole": openstack_networking_port_v2.pihole_port.id
        # "jumpbox_management": openstack_networking_port_v2.jumpbox_management_port.id
        # "jumpbox_homelab": openstack_networking_port_v2.jumpbox_homelab_port.id
    }
}