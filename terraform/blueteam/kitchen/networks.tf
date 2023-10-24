data "openstack_networking_router_v2" "core_router" {
    name = "Core Router"
}

// Blueteam kitchen
resource "openstack_networking_network_v2" "blueteam_kitchen" {
    name = format("Blueteam Kitchen")
}

resource "openstack_networking_subnet_v2" "blueteam_kitchen_subnet" {
    depends_on = [
        openstack_networking_network_v2.blueteam_kitchen
    ]
    name = "Blueteam Kitchen Subnet"
    network_id = openstack_networking_network_v2.blueteam_kitchen.id
    cidr = "10.2.0.0/24"
    gateway_ip = "10.2.0.254"
    ip_version = 4
    allocation_pool {
        start = "10.2.0.200"
        end = "10.2.0.250"
    }
    dns_nameservers = [
        "1.1.1.1",
        "1.0.0.1"
    ]
}

resource "openstack_networking_port_v2" "blueteam_kitchen_subnet_port" {
    name = "Blueteam Kitchen Port"
    network_id = openstack_networking_network_v2.blueteam_kitchen.id
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