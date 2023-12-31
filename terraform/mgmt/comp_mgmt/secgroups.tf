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

Management secgroups

**/

resource "openstack_networking_secgroup_v2" "deploy_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Deploy Secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "deploy_secgroup_rule" {
    for_each = {"ssh": 22}
    description = each.key
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = each.value
    port_range_max = each.value
    security_group_id = openstack_networking_secgroup_v2.deploy_secgroup.id
}

resource "openstack_networking_secgroup_v2" "scorestack_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Scorestack Secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "scorestack_secgroup_rule" {
    for_each = {"http": 80, "https": 443, "logstash": 5454, "elasticsearch": 9200, "transport": 9300, "kibana": 5601, "ssh": 22}
    description = each.key
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = each.value
    port_range_max = each.value
    security_group_id = openstack_networking_secgroup_v2.scorestack_secgroup.id
}

resource "openstack_networking_secgroup_v2" "dns_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Scorestack Secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "dns_secgroup_rule" {
    for_each = {"http": 80, "https": 443, "ssh": 22, "dns": 53}
    description = each.key
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = each.value
    port_range_max = each.value
    security_group_id = openstack_networking_secgroup_v2.dns_secgroup.id
}

resource "openstack_networking_secgroup_v2" "comp_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Compsole Secgroup"
}

resource "openstack_networking_secgroup_rule_v2" "comp_secgroup_rule" {
    for_each = {"http": 80, "https": 443, "ssh": 22}
    description = each.key
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "tcp"
    port_range_min = each.value
    port_range_max = each.value
    security_group_id = openstack_networking_secgroup_v2.comp_secgroup.id
}

resource "openstack_networking_secgroup_v2" "null_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Null Secgroup"
}

locals {
    secgroups = {
        "deploy": openstack_networking_secgroup_v2.deploy_secgroup.id
        "scorestack": openstack_networking_secgroup_v2.scorestack_secgroup.id
        "dns": openstack_networking_secgroup_v2.dns_secgroup.id
        "comp": openstack_networking_secgroup_v2.comp_secgroup.id
        "default": data.openstack_networking_secgroup_v2.default_secgroup.id
        "null": openstack_networking_secgroup_v2.null_secgroup.id
    }
}

// Allows pings
resource "openstack_networking_secgroup_rule_v2" "icmp_rule" {
    for_each = local.secgroups
    description = "icmp"
    direction = "ingress"
    ethertype = "IPv4"
    protocol = "icmp"
    security_group_id = each.value
}