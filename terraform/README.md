# Terraform

This repo holds the terraform for setting up the cloud environment. Some of the baseline stuff is taken from how irsec sets up infra.

To run terraform:
Go into the repo of what portion you want to deploy

- mgmt for management (deploy, scorestack)
- blueteam for blueteam
- redteam for redteam

`terraform plan` to see what it's doing
`terraform apply` to run it
`terraform destroy` to destroy all of your stuff

TODO: 
- Set up secgroups in here
- Add the 'external' router
- Fix openwrt not getting an IP and not able to use cloud init
