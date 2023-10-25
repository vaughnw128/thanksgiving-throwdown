/**

Core router setup

**/

resource "openstack_networking_router_v2" "core_router" {
    name = "Core Router"
    admin_state_up = true
    external_network_id = var.external_network
}

resource "openstack_networking_router_v2" "external_router" {
    name = "External Router"
    admin_state_up = true
    external_network_id = var.external_network
}

/**

Management Network Setup

**/

resource "openstack_networking_network_v2" "management_network" {
    name = "Management Network"
}

resource "openstack_networking_subnet_v2" "management_subnet" {
    name = "Management Subnet"
    network_id = openstack_networking_network_v2.management_network.id
    cidr = "10.100.0.0/24"
    gateway_ip = "10.100.0.254"
    ip_version = 4
    allocation_pool {
        start = "10.100.0.200"
        end = "10.100.0.250"
    }
    dns_nameservers = [
        "1.1.1.1",
        "1.0.0.1",
    ]
}

resource "openstack_networking_port_v2" "management_subnet_port" {
    name = "Management Port"
    network_id = openstack_networking_network_v2.management_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.management_subnet.id
        ip_address = "10.100.0.254"
    }
    port_security_enabled = false
}

resource "openstack_networking_router_interface_v2" "management_external_interface" {
    router_id = openstack_networking_router_v2.external_router.id
    port_id = openstack_networking_port_v2.management_subnet_port.id
}

/**

Floating IP Setup

**/

resource "openstack_networking_floatingip_v2" "public_ip" {
    for_each = toset(["deploy"])
    pool = "external249"
}

resource "openstack_compute_floatingip_associate_v2" "public_instance_ip_associate" {
    for_each = toset(["deploy"])
    depends_on = [
        openstack_compute_instance_v2.management_instance["deploy"]
    ]
    floating_ip = openstack_networking_floatingip_v2.public_ip[each.key].address
    instance_id = openstack_compute_instance_v2.management_instance[each.key].id
}