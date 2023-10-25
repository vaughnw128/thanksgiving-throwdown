/**

Variables

**/


data "openstack_networking_router_v2" "core_router" {
    name = "Core Router"
}

data "openstack_networking_network_v2" "competition_cloud_network" {
    name = "Competition Cloud Network"
}

data "openstack_networking_subnet_v2" "management_subnet" {
    name = "Management Subnet"
}

/**

Blueteam homelab subnet and network information

**/

# resource "openstack_networking_router_v2" "blueteam_homelab_router" {
#     name = "Homelab Router"
#     admin_state_up = true
#     external_network_id = var.external_network
# }

resource "openstack_networking_network_v2" "blueteam_homelab" {
    name = "Blueteam Homelab"
}

resource "openstack_networking_subnet_v2" "blueteam_homelab_subnet" {
    depends_on = [
        openstack_networking_network_v2.blueteam_homelab
    ]
    name = "Blueteam Homelab Subnet"
    network_id = openstack_networking_network_v2.blueteam_homelab.id
    cidr = "10.1.0.0/24"
    gateway_ip = "10.1.0.254"
    ip_version = 4
    allocation_pool {
        start = "10.1.0.200"
        end = "10.1.0.250"
    }
    dns_nameservers = [
        "1.1.1.1",
        "1.0.0.1"
    ]
}

resource "openstack_networking_port_v2" "blueteam_homelab_subnet_port" {
    name = "Blueteam Homelab Port"
    network_id = openstack_networking_network_v2.blueteam_homelab.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_homelab_subnet.id
        ip_address = "10.1.0.254"
    }
    port_security_enabled = false
}

resource "openstack_networking_router_interface_v2" "blueteam_homelab_interface" {
    router_id = data.openstack_networking_router_v2.core_router.id
    port_id = openstack_networking_port_v2.blueteam_homelab_subnet_port.id
}

# resource "openstack_networking_router_interface_v2" "blueteam_homelab_interface" {
#     router_id = data.openstack_networking_router_v2.core_router.id
#     port_id = openstack_networking_port_v2.blueteam_homelab_subnet_port.id
# }