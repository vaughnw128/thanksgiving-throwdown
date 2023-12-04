/**

Management ports

**/

resource "openstack_networking_port_v2" "deploy_port" {
    name = "Deploy Port"
    network_id = openstack_networking_network_v2.competition_cloud_network.id
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
    network_id = openstack_networking_network_v2.competition_cloud_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.management_subnet.id
        ip_address = "10.100.0.2"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["scorestack"]
    ]
}

resource "openstack_networking_port_v2" "dns_port" {
    name = "DNS Port"
    network_id = openstack_networking_network_v2.competition_cloud_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.management_subnet.id
        ip_address = "10.100.0.3"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["dns"]
    ]
}

resource "openstack_networking_port_v2" "comp_port" {
    name = "Compsole Port"
    network_id = openstack_networking_network_v2.competition_cloud_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.management_subnet.id
        ip_address = "10.100.0.4"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["comp"]
    ]
}

locals {
    ports = {
        "deploy": openstack_networking_port_v2.deploy_port.id
        "scoring": openstack_networking_port_v2.scoring_port.id
        "dns": openstack_networking_port_v2.dns_port.id
        "comp": openstack_networking_port_v2.comp_port.id
    }
}
