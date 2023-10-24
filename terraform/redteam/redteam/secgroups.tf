/**

Variables

**/

data "openstack_identity_project_v3" "management_project" {
    name = var.tenant_name
}

data "openstack_networking_secgroup_v2" "default_secgroup" {
    secgroup_id = "23f0b9f4-84b0-4ba2-9f8c-a68a86fd011f"
}

/**

Secgroups for jumpbox

**/

resource "openstack_networking_secgroup_v2" "redteam_jumpbox_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Redteam Jumpbox Secgroup"

}

resource "openstack_networking_secgroup_rule_v2" "redteam_jumpbox_secgroup_rule" {
    for_each = {"ssh": 22, "http": 80, "https": 443}
    description = each.key
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = each.value
    port_range_max = each.value
    security_group_id = openstack_networking_secgroup_v2.redteam_jumpbox_secgroup.id
}

/**

Redteam secgroups

**/

resource "openstack_networking_secgroup_v2" "redteam_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Redteam Secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "redteam_secgroup_rule" {
    for_each = {"ssh": 22, "http": 80, "https": 443}
    description = each.key
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = each.value
    port_range_max = each.value
    security_group_id = openstack_networking_secgroup_v2.redteam_secgroup.id
}

locals {
    secgroups = {
        "jumpbox": openstack_networking_secgroup_v2.redteam_jumpbox_secgroup.id
        "redteam": openstack_networking_secgroup_v2.redteam_secgroup.id
        "default": data.openstack_networking_secgroup_v2.default_secgroup.id
    }
}