<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~> 1.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | ~> 1.48.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [openstack_compute_instance_v2.team_cloud_instance](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_networking_port_v2.drill_port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.overwatch_port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.pipeline_port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.tank_port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.team_core_router_port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_router_interface_v2.core_router_cloud_interface](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_router_interface_v2) | resource |
| [openstack_networking_secgroup_rule_v2.cloud_secgroup_rule](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_rule_v2) | resource |
| [openstack_networking_secgroup_v2.team_cloud_secgroup](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_secgroup_v2) | resource |
| [openstack_networking_subnet_v2.team_cloud_subnet](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_subnet_v2) | resource |
| [openstack_identity_project_v3.management_project](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/identity_project_v3) | data source |
| [openstack_networking_network_v2.competition_network](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/networking_network_v2) | data source |
| [openstack_networking_router_v2.core_router](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/networking_router_v2) | data source |
| [openstack_networking_secgroup_v2.default_secgroup](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/data-sources/networking_secgroup_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_competition_domain"></a> [competition\_domain](#input\_competition\_domain) | Domain for the competition | `string` | n/a | yes |
| <a name="input_competition_name"></a> [competition\_name](#input\_competition\_name) | Name of the competition (e.g. ISTS) | `string` | n/a | yes |
| <a name="input_hosts"></a> [hosts](#input\_hosts) | Map of VM details hostname:vars | `map` | n/a | yes |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Tags for Instances | `set(string)` | n/a | yes |
| <a name="input_team_num"></a> [team\_num](#input\_team\_num) | Number of team to provision | `number` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | project name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->