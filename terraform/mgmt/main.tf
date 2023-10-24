provider "openstack" {
    tenant_name = var.project_name
    user_name = var.username
    password = var.password
    auth_url = var.auth_url
}

/**

Variables

**/

data "openstack_identity_project_v3" "management_project" {
    name = var.project_name
}

data "openstack_networking_network_v2" "external_network" {
    name = "external249"
}

data "openstack_images_image_v2" "image_ubuntu_22" {
    name = "UbuntuJammy2204"
}

// Flavor Data
data "openstack_compute_flavor_v2" "flavor_linux_medium" {
    name = "small"
}

/**

Competition management module

**/

module "comp_mgmt" {
    source ="./comp_mgmt"
    competition_domain = var.competition_domain
    competition_name = var.competition_name
    tenant_name = var.project_name
    inherited_tags = var.inherited_tags
    external_network = data.openstack_networking_network_v2.external_network.id
    project_id = data.openstack_identity_project_v3.management_project.id
    
    hosts = {
        "scoring": {
            "image": data.openstack_images_image_v2.image_ubuntu_22.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
            "size": 50
            "mgmt_port": "scoring"
            "secgroup": "scorestack"
            "user_data": file("../files/cloud-init-ubuntu.yaml")
        }
        "deploy": {
            "image": data.openstack_images_image_v2.image_ubuntu_22.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
            "size": 20
            "mgmt_port": "deploy"
            "secgroup": "deploy"
            "user_data": file("../files/cloud-init-ubuntu.yaml")
        }
    }
}
