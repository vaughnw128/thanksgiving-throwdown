data "openstack_identity_project_v3" "management_project" {
    name = var.tenant_name
}

data "openstack_networking_secgroup_v2" "redteam_secgroup" {
    secgroup_id = "3d8abe1c-6cd1-4d89-b118-f1acd35df5cc"
}

data "openstack_networking_secgroup_v2" "null_secgroup" {
    secgroup_id = "08b4a6c5-b129-45de-bdb1-77a4b1ad9e3a"
}

data "openstack_networking_secgroup_v2" "default_secgroup" {
    secgroup_id = "23f0b9f4-84b0-4ba2-9f8c-a68a86fd011f"
}

resource "openstack_networking_secgroup_v2" "redteam_jumpbox_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Redteam Jumpbox Secgroup"

}
resource "openstack_networking_secgroup_rule_v2" "redteam_jumpbox_secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.redteam_jumpbox_secgroup.id
}

locals {
    secgroups = {
        "jumpbox": openstack_networking_secgroup_v2.redteam_jumpbox_secgroup.id
        "redteam": data.openstack_networking_secgroup_v2.redteam_secgroup.id
        "default": data.openstack_networking_secgroup_v2.default_secgroup.id
        "null": data.openstack_networking_secgroup_v2.null_secgroup.id
    }
}