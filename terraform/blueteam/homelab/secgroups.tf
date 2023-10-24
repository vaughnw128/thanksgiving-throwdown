// Blueteam Homelab Security Groups
data "openstack_identity_project_v3" "management_project" {
    name = var.tenant_name
}

resource "openstack_networking_secgroup_v2" "blueteam_homelab_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Blueteam Homelab Secgroup"
}
resource "openstack_networking_secgroup_rule_v2" "blueteam_homelab_secgroup_rule" {
    direction = "ingress"
    ethertype = "IPv4"
    security_group_id = openstack_networking_secgroup_v2.blueteam_homelab_secgroup.id
}

resource "openstack_networking_secgroup_v2" "blueteam_jumpbox_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Blueteam Jumpbox Secgroup"

}
resource "openstack_networking_secgroup_rule_v2" "blueteam_jumpbox_secgroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.blueteam_jumpbox_secgroup.id
}

data "openstack_networking_secgroup_v2" "default_secgroup" {
    secgroup_id = "23f0b9f4-84b0-4ba2-9f8c-a68a86fd011f"
}

locals {
    secgroups = {
        "default": data.openstack_networking_secgroup_v2.default_secgroup.id
        "homelab": openstack_networking_secgroup_v2.blueteam_homelab_secgroup.id
        "jumpbox": openstack_networking_secgroup_v2.blueteam_jumpbox_secgroup.id
    }
}