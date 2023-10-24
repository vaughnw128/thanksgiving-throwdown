// Blueteam Kitchen Security Groups
data "openstack_identity_project_v3" "management_project" {
    name = var.tenant_name
}

resource "openstack_networking_secgroup_v2" "blueteam_kitchen_secgroup" {
    tenant_id = data.openstack_identity_project_v3.management_project.id
    name = "Blueteam Homelab Secgroup"
}
resource "openstack_networking_secgroup_rule_v2" "blueteam_kitchen_secgroup_rule" {
    direction = "ingress"
    ethertype = "IPv4"
    security_group_id = openstack_networking_secgroup_v2.blueteam_kitchen_secgroup.id
}

data "openstack_networking_secgroup_v2" "default_secgroup" {
    secgroup_id = "23f0b9f4-84b0-4ba2-9f8c-a68a86fd011f"
}

locals {
    secgroups = {
        "default": data.openstack_networking_secgroup_v2.default_secgroup.id
        "kitchen": openstack_networking_secgroup_v2.blueteam_kitchen_secgroup.id
    }
}