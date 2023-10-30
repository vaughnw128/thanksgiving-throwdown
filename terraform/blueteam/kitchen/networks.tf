/**

Variables

**/

data "openstack_networking_router_v2" "core_router" {
    name = "Core Router"
}

data "openstack_networking_network_v2" "competition_cloud_network" {
    name = "Competition Cloud Network"
}

/**

Kitchen subnet information

**/

resource "openstack_networking_subnet_v2" "blueteam_kitchen_subnet" {
    name = "Blueteam Kitchen Subnet"
    network_id = data.openstack_networking_network_v2.competition_cloud_network.id
    cidr = "10.2.0.0/24"
    gateway_ip = "10.2.0.254"
    ip_version = 4
    allocation_pool {
        start = "10.2.0.200"
        end = "10.2.0.250"
    }
    dns_nameservers = [
        "10.100.0.3",
        "1.1.1.1",
        "1.0.0.1"
    ]
}

resource "openstack_networking_port_v2" "blueteam_kitchen_subnet_port" {
    name = "Blueteam Kitchen Port"
    network_id = data.openstack_networking_network_v2.competition_cloud_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_kitchen_subnet.id
        ip_address = "10.2.0.254"
    }
    port_security_enabled = false
}

resource "openstack_networking_router_interface_v2" "blueteam_kitchen_interface" {
    router_id = data.openstack_networking_router_v2.core_router.id
    port_id = openstack_networking_port_v2.blueteam_kitchen_subnet_port.id
}