/**

Variables

**/

data "openstack_identity_project_v3" "management_project" {
    name = var.tenant_name
}

data "openstack_networking_secgroup_v2" "default_secgroup" {
    secgroup_id = "df7d77a2-adf9-433c-9e4f-240ebebb8ed5"
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
        "redteam": openstack_networking_secgroup_v2.redteam_secgroup.id
        "default": data.openstack_networking_secgroup_v2.default_secgroup.id
    }
}