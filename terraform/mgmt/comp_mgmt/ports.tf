/**

Management ports

**/

resource "openstack_networking_port_v2" "deploy_port" {
    name = "Deploy Port"
    network_id = openstack_networking_network_v2.management_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.management_subnet.id
        ip_address = "10.100.0.1"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["deploy"]
    ]
}

resource "openstack_networking_port_v2" "scoring_port" {
    name = "Scoring Port"
    network_id = openstack_networking_network_v2.management_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.management_subnet.id
        ip_address = "10.100.0.2"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["scorestack"]
    ]
}

locals {
    ports = {
        "deploy": openstack_networking_port_v2.deploy_port.id
        "scoring": openstack_networking_port_v2.scoring_port.id
    }
}
