provider "openstack" {
    user_name = var.username
    password = var.password
    auth_url = var.auth_url
    tenant_name = var.project_name
}

/**

Variables

**/

data "openstack_networking_network_v2" "external_network" {
    name = "external249"
}

data "openstack_identity_project_v3" "management_project" {
    name = var.project_name
}

data "openstack_images_image_v2" "image_linux_ubuntu" {
    name = "UbuntuJammy2204"
}

data "openstack_images_image_v2" "image_linux_openwrt" {
    name = "OpenWRTCloud"
}

data "openstack_images_image_v2" "image_windows_2019" {
    name = "WinSrv2019-17763-2022"
}

data "openstack_images_image_v2" "image_linux_raspbian" {
    name = "Raspbian"
}

data "openstack_images_image_v2" "image_linux_raspios" {
    name = "RaspiOSConfigured"
}

data "openstack_images_image_v2" "image_windows_10" {
    name = "Win10-21H2"
}

// Flavor Data
data "openstack_compute_flavor_v2" "flavor_linux_medium" {
    name = "small"
}

data "openstack_compute_flavor_v2" "flavor_linux_small" {
    name = "small"
}

data "openstack_compute_flavor_v2" "flavor_linux_tiny" {
    name = "tiny"
}

data "openstack_compute_flavor_v2" "flavor_windows_medium" {
    name = "medium"
}

data "openstack_compute_flavor_v2" "flavor_windows_small" {
    name = "small"
}

/**

Homelab module

**/

module "homelab" {

    source = "./homelab"

    tenant_name = var.project_name
    competition_name = var.competition_name
    competition_domain = var.competition_domain
    inherited_tags = var.inherited_tags
    external_network = data.openstack_networking_network_v2.external_network.id

    // Defines the jumpbox
    # jumpbox = {
    #     "hostname": "jumpbox"
    #     "image": data.openstack_images_image_v2.image_linux_ubuntu.id
    #     "flavor": data.openstack_compute_flavor_v2.flavor_linux_small.id
    #     "size": 30
    #     "homelab_port": "jumpbox_homelab"
    #     "management_port": "jumpbox_management"
    #     "user_data": file("../files/cloud-init-ubuntu.yaml")
    # }

    // Defines the hosts on homelab network
    hosts = {
        "dc": {
            "image": data.openstack_images_image_v2.image_windows_2019.id
            "flavor": data.openstack_compute_flavor_v2.flavor_windows_medium.id
            "size": 80
            "port": "dc"
            "user_data": file("../files/cloudbase-config.ps1")
        }
        "pc": {
            "image": data.openstack_images_image_v2.image_windows_10.id
            "flavor": data.openstack_compute_flavor_v2.flavor_windows_medium.id
            "size": 45
            "port": "pc"
            "user_data": file("../files/cloudbase-config.ps1")
        }
        "media": {
            "image": data.openstack_images_image_v2.image_linux_ubuntu.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_small.id
            "size": 30
            "port": "media"
            "user_data": file("../files/cloud-init-ubuntu.yaml")
        }
        "pihole": {
            "image": data.openstack_images_image_v2.image_linux_raspios.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_small.id
            "size": 30
            "port": "pihole"
            # "user_data": file("../files/pi_img/user-data.yaml")
        }
    }

}

/**

Kitchen Module

**/

module "kitchen" {

    source = "./kitchen"

    tenant_name = var.project_name
    competition_name = var.competition_name
    competition_domain = var.competition_domain
    inherited_tags = var.inherited_tags
    
    // Defines hosts on kitchen (cloud) network
    hosts = {
        "fridge": {
            "image": data.openstack_images_image_v2.image_linux_openwrt.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_tiny.id
            "size": 20
            "port": "fridge"
            "user_data": file("../files/user-data.sh")
        }
        "cabinet": {
            "image": data.openstack_images_image_v2.image_linux_openwrt.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_tiny.id
            "size": 20
            "port": "cabinet"
            "user_data": file("../files/user-data.sh")
        }
        "oven": {
            "image": data.openstack_images_image_v2.image_linux_openwrt.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_tiny.id
            "size": 20
            "port": "oven"
            "user_data": file("../files/user-data.sh")
        }
        "lights": {
            "image": data.openstack_images_image_v2.image_linux_openwrt.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_tiny.id
            "size": 20
            "port": "lights"
            "user_data": file("../files/user-data.sh")
        }
        "freezer": {
            "image": data.openstack_images_image_v2.image_linux_openwrt.id
            "flavor": data.openstack_compute_flavor_v2.flavor_linux_tiny.id
            "size": 20
            "port": "freezer"
            "user_data": file("../files/user-data.sh")
        }
    }
}