resource "openstack_networking_port_v2" "jumpbox_management_port"{
    name = "Redteam Jumpbox Management"
    network_id = data.openstack_networking_network_v2.management_network.id
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["jumpbox"]
    ]
}

resource "openstack_networking_port_v2" "jumpbox_redteam_port"{
    name = "Redteam Jumpbox Rednet"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.100"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["jumpbox"]
    ]
}

resource "openstack_networking_port_v2" "redteam_one_port" {
    name = "Redteam #1 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.1"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}

resource "openstack_networking_port_v2" "redteam_two_port" {
    name = "Redteam #2 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.2"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}

resource "openstack_networking_port_v2" "redteam_three_port" {
    name = "Redteam #3 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.3"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}


resource "openstack_networking_port_v2" "redteam_four_port" {
    name = "Redteam #4 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.4"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}


resource "openstack_networking_port_v2" "redteam_five_port" {
    name = "Redteam #5 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.5"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}

resource "openstack_networking_port_v2" "redteam_six_port" {
    name = "Redteam #6 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.6"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}

resource "openstack_networking_port_v2" "redteam_seven_port" {
    name = "Redteam #7 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.7"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}


resource "openstack_networking_port_v2" "redteam_eight_port" {
    name = "Redteam #8 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.8"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}


resource "openstack_networking_port_v2" "redteam_nine_port" {
    name = "Redteam #9 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.9"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}

resource "openstack_networking_port_v2" "redteam_ten_port" {
    name = "Redteam #10 Port"
    network_id = openstack_networking_network_v2.redteam_network.id
    fixed_ip {
        subnet_id = openstack_networking_subnet_v2.redteam_subnet.id
        ip_address = "10.50.0.10"
    }
    security_group_ids = [
        local.secgroups["default"],
        local.secgroups["redteam"]
    ]    
}

locals {
    ports = {
        "jumpbox_management": openstack_networking_port_v2.jumpbox_management_port.id
        "jumpbox_redteam": openstack_networking_port_v2.jumpbox_redteam_port.id
        "redteam_one": openstack_networking_port_v2.redteam_one_port.id
        "redteam_two": openstack_networking_port_v2.redteam_two_port.id
        "redteam_three": openstack_networking_port_v2.redteam_three_port.id
        "redteam_four": openstack_networking_port_v2.redteam_four_port.id
        "redteam_five": openstack_networking_port_v2.redteam_five_port.id
        "redteam_six": openstack_networking_port_v2.redteam_six_port.id
        "redteam_seven": openstack_networking_port_v2.redteam_seven_port.id
        "redteam_eight": openstack_networking_port_v2.redteam_eight_port.id
        "redteam_nine": openstack_networking_port_v2.redteam_nine_port.id
        "redteam_ten": openstack_networking_port_v2.redteam_ten_port.id
    }
}