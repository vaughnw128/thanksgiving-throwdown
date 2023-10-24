/**

Variables

**/

data "openstack_networking_router_v2" "core_router" {
    name = "Core Router"
}

data "openstack_networking_network_v2" "management_network" {
    name = "Management Network"
}

data "openstack_networking_subnet_v2" "management_subnet" {
    name = "Management Subnet"
}

/**

Redteam network

**/

resource "openstack_networking_network_v2" "redteam_network" {
    name = "Redteam Network"
}

resource "openstack_networking_subnet_v2" "redteam_subnet" {
    name = "Redteam Subnet"
    network_id = openstack_networking_network_v2.redteam_network.id
    cidr = "10.50.0.0/24"
    gateway_ip = "10.50.0.254"
    ip_version = 4
    allocation_pool {
        start = "10.50.0.200"
        end = "10.50.0.250"
    }
    dns_nameservers = [
        "1.1.1.1",
        "1.0.0.1"
    ]
}

resource "openstack_networking_port_v2" "redteam_subnet_port" {
    name = "Redteam Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.254"
    }
    port_security_enabled = false
}

resource "openstack_networking_router_interface_v2" "redteam_interface" {
    router_id = data.openstack_networking_router_v2.core_router.id
    port_id = openstack_networking_port_v2.redteam_subnet_port.id
}