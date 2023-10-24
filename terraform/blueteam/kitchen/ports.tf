/**

Network ports with static IPs for smart home devices

**/

resource "openstack_networking_port_v2" "fridge_port"{
    name = "Blueteam Kitchen Fridge"
    network_id = openstack_networking_network_v2.blueteam_kitchen.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_kitchen_subnet.id
        ip_address = "10.2.0.1"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["kitchen"]
    ]
}

resource "openstack_networking_port_v2" "cabinet_port"{
    name = "Blueteam Kitchen Cabinet"
    network_id = openstack_networking_network_v2.blueteam_kitchen.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_kitchen_subnet.id
        ip_address = "10.2.0.2"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["kitchen"]
    ]
}

resource "openstack_networking_port_v2" "oven_port"{
    name = "Blueteam Kitchen Oven"
    network_id = openstack_networking_network_v2.blueteam_kitchen.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_kitchen_subnet.id
        ip_address = "10.2.0.3"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["kitchen"]
    ]
}

resource "openstack_networking_port_v2" "lights_port"{
    name = "Blueteam Kitchen Lights"
    network_id = openstack_networking_network_v2.blueteam_kitchen.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_kitchen_subnet.id
        ip_address = "10.2.0.4"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["kitchen"]
    ]
}

resource "openstack_networking_port_v2" "freezer_port"{
    name = "Blueteam Kitchen Freezer"
    network_id = openstack_networking_network_v2.blueteam_kitchen.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.blueteam_kitchen_subnet.id
        ip_address = "10.2.0.5"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["kitchen"]
    ]
}

locals {
    ports = {
        "fridge": openstack_networking_port_v2.fridge_port.id
        "cabinet": openstack_networking_port_v2.cabinet_port.id
        "oven": openstack_networking_port_v2.oven_port.id
        "lights": openstack_networking_port_v2.lights_port.id
        "freezer": openstack_networking_port_v2.freezer_port.id
    }
}