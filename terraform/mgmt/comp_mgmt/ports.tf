resource "openstack_networking_port_v2" "deploy_pri_port" {
    name = "${var.competition_name} Deploy Private Port"
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

resource "openstack_networking_port_v2" "scoring_pri_port" {
    name = "${var.competition_name} Scoring Private Port"
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
        "deploy_pri": openstack_networking_port_v2.deploy_pri_port.id
        "scoring_pri": openstack_networking_port_v2.scoring_pri_port.id
    }
}
