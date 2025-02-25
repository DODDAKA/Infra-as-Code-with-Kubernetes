//tags
tags = {
  "Environment" = "PROD"
  "Created By"  = "naveen"
  "Owner name"  = "@dnk"
}
// rg-variables
rg_name     = "rg-dnk-cvs-prod-cus-001"
rg_location = "centralus"

//vnet-variables
vnet_name          = "vnet-dnk-cvs-prod-cus-001"
vnet_address-space = ["10.14.48.0/20"]
vnet_ddos_plan     = "ddosvnet-dnk-cvs-prod-cus-001"

//snet-variables
#snet_rt = "rt-dnk-cvs-prod-cus-001"

snet_1_name          = "snet-prod-app-cus-001"
snet_1_address_space = ["10.14.48.0/23"]
snet_1_nsg           = "nsg-prod-app-cus-001"

snet_2_name          = "snet-prod-db-cus-001"
snet_2_address_space = ["10.14.50.0/24"]
snet_2_nsg           = "nsg-prod-db-cus-001"

snet_3_name          = "snet-prod-db-cus-002"
snet_3_address_space = ["10.14.51.0/24"]
snet_3_nsg           = "nsg-prod-db-cus-002"

snet_4_name          = "snet-prod-web-cus-001"
snet_4_address_space = ["10.14.52.0/24"]
snet_4_nsg           = "nsg-prod-web-cus-001"

snet_5_name          = "snet-prod-dmz-cus-001"
snet_5_address_space = ["10.14.53.0/24"]
snet_5_nsg           = "nsg-prod-dmz-cus-001"

snet_6_name          = "snet-prod-infra-cus-001"
snet_6_address_space = ["10.14.54.0/24"]
snet_6_nsg           = "nsg-prod-infra-cus-001"

//vnet-peering
sub1_to_sub2_name = "vnet_peering_hub_to_cvs-prod"
sub2_to_sub1_name = "vnet_peering_cvs-prod_to_hub"

//nsg-name
#snet_nsg_name = "nsg-prod-app-cus-001"

kubernetes_version                       = "1.29.7"
sku_tier                                 = "Standard"

default_node_pool_name                   = "system"
default_node_pool_vm_size                = "Standard_E8ads_v5"
default_node_pool_enable_auto_scaling    = true
default_node_pool_availability_zones     = ["1","2","3"]
default_node_pool_enable_host_encryption = false
default_node_pool_enable_node_public_ip  = false
default_node_pool_max_pods               = 50
default_node_pool_os_disk_type           = "Managed"
default_node_pool_max_count              = 2
default_node_pool_min_count              = 1
default_node_pool_node_count             = 1

admin_username                           = "azadmin"
SSH_PUBLIC_KEY                           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGrH81dUwr59e1Q1J4lem9KH09Ys03ecWk49/7WPn0WuzW87AuquElNSoD6ehVz/9alGIGZAH1kFc+QVCScmarI+zKhbHdO0njPPI019OYUbazQbVxxYNlEkO3MBEGrsjFb8BUEa3GbjNtbTaS7EVYteoEgANwR8lMNzuEoeImFqyIiUYWzV8fpk5FaAuELnnGcstXvVZfrOdhebekj7wQWVDfE7AWehHz/yt+2ml21rBI98hHch47HJkPoDeYwDFnhNVsrkxicHNNV37Q0Tb2nYO4ByF91EZhktUJoiO1ijSq4RtZ9xc7meY7DE51pWOvsdLFc/q1b3b/wMjjtgs7flcgetHmhCbJV0ZiNFfisyEdfYCYciChir4UXMKlHt04z44Y0vP9vJaTvvzIoxT44/Sql/UTHxG9FuYO/DGXR0HMalGpWtJ9PHhH3pjHNJ7l//AVUb8PmTpvL1YurEdBYiba2a29a+atjmeY1JxIOU0sGBHGB3boZM/WuNeq608pkC2ZsQ1PwR8WdUrRU/ihGC51RkPWEkSMt7fmwySeU6mZqggiSI7WNZ5oGFzGUGjtmF9CIw0Gw6gE3ERCCn0soA2qoBnro9mJfiHynfzjtCo+eSNMRrfAa9jhXXfGtghRePhku5Hzbr2wWD/blC9U0HrNelE3ptDm9oViBW7xvQ== msradmin@hubcusjumphost"
tenant_id = "5a719b12-79ad-4f3f-b39e-dd9da8f735ed"

network_dns_service_ip                   = "10.2.0.10"
network_service_cidr                     = "10.2.0.0/16"
network_plugin                           = "azure"