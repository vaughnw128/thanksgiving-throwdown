provider "openstack" {
    user_name = var.username
    password = var.password
    auth_url = var.auth_url
    tenant_name = var.project_name
}

/**

Variables

**/

data "openstack_identity_project_v3" "management_project" {
    name = var.project_name
}

data "openstack_images_image_v2" "image_ubuntu_22" {
    name = "UbuntuJammy2204"
}

data "openstack_networking_network_v2" "external_network" {
    name = "external249"
}

data "openstack_images_image_v2" "image_kali" {
    name = "Kali-2023.1"
}

data "openstack_compute_flavor_v2" "flavor_linux_medium" {
    name = "small"
}

/**

Redteam module

**/

module "redteam" {
    source ="./redteam"
    competition_domain = var.competition_domain
    tenant_name = var.project_name
    competition_name = var.competition_name
    inherited_tags = var.inherited_tags
    external_network = data.openstack_networking_network_v2.external_network.id
    project_id = data.openstack_identity_project_v3.management_project.id

    // Jumpbox host
    jumpbox = {
        "hostname": "jumpbox"
        "image": data.openstack_images_image_v2.image_ubuntu_22.id
        "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        "size": 30
        "redteam_port": "jumpbox_redteam"
        "management_port": "jumpbox_management"
        "user_data": file("../files/cloud-init-ubuntu.yaml")
    }

    // All redteam hosts
    redteam_hosts = {
        "one": {
            "image": data.openstack_images_image_v2.image_kali.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
            "size": 81
            "redteam_port": "redteam_one"
            "secgroup": "redteam"
            "user_data": file("../files/cloud-init-redteam.yaml")
        }
        # "two": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 81
        #     "redteam_port": "redteam_two"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")   
        # }
        # "three": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_three"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")   
        # }
        # "four": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_four"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml") 
        # }
        # "five": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_five"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")
        # }
        # "six": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_six"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")
        # }
        # "seven": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_seven"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")
        # }
        # "eight": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_eight"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")
        # }
        # "nine": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_nine"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")
        # }
        # "ten": {
        #     "image": data.openstack_images_image_v2.image_kali.id
        #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_medium.id
        #     "size": 20
        #     "redteam_port": "redteam_ten"
        #     "secgroup": "redteam"
        #     "user_data": file("../files/cloud-init-redteam.yaml")
        # }
    }
}