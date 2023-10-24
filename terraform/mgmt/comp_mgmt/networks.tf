locals {
    team_range = ["1","2"]
}

// Build the core router
resource "openstack_networking_router_v2" "core_router" {
    name = "Core Router"
    admin_state_up = true
    external_network_id = var.external_network
}

# // Build the external management router
# resource "openstack_networking_router_v2" "management_router" {
#     name = "${var.competition_name} Management Router"
#     admin_state_up = true
#     external_network_id = var.external_network
# }

/**

Competition Network Setup

**/

# // Competition Network
# resource "openstack_networking_network_v2" "competition_network" {
#     name = "${var.competition_name} Competition Network"
# }

# // create comp network 
# resource "openstack_networking_subnet_v2" "comp_subnet" {
#     name = "${var.competition_name} Competition Subnet"
#     network_id = openstack_networking_network_v2.competition_network.id
#     cidr = "10.1.0.0/24"
#     gateway_ip = "10.1.0.254"
#     ip_version = 4
#     allocation_pool {
#         start = "10.1.0.200"
#         end = "10.1.0.250"
#     }
#     dns_nameservers = [
#         "1.1.1.1",
#         "1.0.0.1",
#     ]
# }

# resource "openstack_networking_port_v2" "comp_subnet_port" {
#     name = "${var.competition_name} Competition Port"
#     network_id = openstack_networking_network_v2.competition_network.id
#     fixed_ip {
#         subnet_id = openstack_networking_subnet_v2.comp_subnet.id
#         ip_address = "10.1.0.254"
#     }
# }

# resource "openstack_networking_router_interface_v2" "comp_interface" {
#     router_id = openstack_networking_router_v2.core_router.id
#     port_id = openstack_networking_port_v2.comp_subnet_port.id
# }

# resource "openstack_networking_subnet_route_v2" "comp_to_team_route" {
#     for_each = toset(local.team_range)
#     subnet_id = openstack_networking_subnet_v2.comp_subnet.id
#     destination_cidr = "10.1.${each.key}.0/24"
#     next_hop = "10.1.0.${each.key}"
# }

/**

Management Network Setup

**/

// Management Network
resource "openstack_networking_network_v2" "management_network" {
    name = "Management Network"
}

// the management subnet, and connection to the core router
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

// Adds routing from Management subnet to the core router
resource "openstack_networking_port_v2" "management_subnet_port" {
    name = "Management Subnet Port"
    network_id = openstack_networking_network_v2.management_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.management_subnet.id
        ip_address = "10.100.0.254"
    }
    port_security_enabled = false
}

// Interface for management port
resource "openstack_networking_router_interface_v2" "management_core_interface" {
    router_id = openstack_networking_router_v2.core_router.id
    port_id = openstack_networking_port_v2.management_subnet_port.id
}

# // Interface for management port
# resource "openstack_networking_router_interface_v2" "management_management_interface" {
#     router_id = openstack_networking_router_v2.management_router.id
#     port_id = openstack_networking_port_v2.management_subnet_port.id
# }

/**

Floating IP Setup

**/

// Floating IPs
resource "openstack_networking_floatingip_v2" "public_ip" {
    for_each = toset(["deploy"])
    pool = "external249"
}

resource "openstack_compute_floatingip_associate_v2" "public_instance_ip_associate" {
    for_each = toset(["deploy"])
    depends_on = [
        openstack_compute_instance_v2.public_instance["deploy"]
    ]
    floating_ip = openstack_networking_floatingip_v2.public_ip[each.key].address
    instance_id = openstack_compute_instance_v2.public_instance[each.key].id
}