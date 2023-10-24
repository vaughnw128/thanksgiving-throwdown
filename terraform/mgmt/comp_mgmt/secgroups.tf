data "openstack_networking_secgroup_v2" "deploy_secgroup" {
    secgroup_id = "d7dd79bc-e501-47f0-8fbc-da9cb2baf162"
}

data "openstack_networking_secgroup_v2" "scorestack_secgroup" {
    secgroup_id = "666c0f9f-1c51-483f-8b1c-c5d5e4b56670"
}

data "openstack_networking_secgroup_v2" "null_secgroup" {
    secgroup_id = "08b4a6c5-b129-45de-bdb1-77a4b1ad9e3a"
}

data "openstack_networking_secgroup_v2" "default_secgroup" {
    secgroup_id = "23f0b9f4-84b0-4ba2-9f8c-a68a86fd011f"
}

locals {
    secgroups = {
        "deploy": data.openstack_networking_secgroup_v2.deploy_secgroup.id
        "scorestack": data.openstack_networking_secgroup_v2.scorestack_secgroup.id
        "default": data.openstack_networking_secgroup_v2.default_secgroup.id
        "null": data.openstack_networking_secgroup_v2.null_secgroup.id
    }
}

resource "openstack_networking_secgroup_rule_v2" "icmp_rule" {
    for_each = local.secgroups
    description = "icmp"
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "icmp"
    security_group_id = each.value
}

