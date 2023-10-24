provider "openstack" {
    tenant_name = var.project_name
    user_name = var.username
    password = var.password
    auth_url = var.auth_url
}

// Management Project
data "openstack_identity_project_v3" "management_project" {
    name = var.project_name
}

// Openstack External Network
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

// comp mgmt 
module "comp_mgmt" {
    source ="./comp_mgmt"
    competition_domain = var.competition_domain
    competition_name = var.competition_name
    inherited_tags = var.inherited_tags
    external_network = data.openstack_networking_network_v2.external_network.id
    project_id = data.openstack_identity_project_v3.management_project.id
    
    private_hosts = {
        // the scoring host for scorestack. sits on the alternate network
        "scoring": {
            "image": data.openstack_images_image_v2.image_ubuntu_22.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
            "size": 50
            "mgmt_port": "scoring_pri"
            "secgroup": "scorestack"
            "user_data": file("../files/cloud-init-ubuntu.yaml")
        }
    }

    public_hosts = {
        // the deploy host to run team terraform on, and then team ansible. sits on the management network.
        "deploy": {
            "image": data.openstack_images_image_v2.image_ubuntu_22.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
            "size": 20
            "mgmt_port": "deploy_pri"
            "secgroup": "deploy"
            "user_data": file("../files/cloud-init-ubuntu.yaml")
        }
    }
}
