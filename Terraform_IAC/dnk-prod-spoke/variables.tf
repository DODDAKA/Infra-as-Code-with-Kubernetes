
variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vnet_name" {
  type = string
  description = "This is Spoke VNET"
}

variable "vnet_address-space" {
  type = list(string)
  description = "VNET address space"
}

variable "tags" {
  type = map(string)
}

variable "vnet_ddos_plan" {
  type = string
}

variable "snet_1_name" {
  type = string
}

variable "snet_1_address_space" {
  type = list(string)
}

variable "snet_1_nsg" {
  type = string
}

variable "snet_2_name" {
  type = string
}

variable "snet_2_address_space" {
  type = list(string)
}

variable "snet_2_nsg" {
  type = string
}

variable "snet_3_name" {
  type = string
}

variable "snet_3_address_space" {
  type = list(string)
}

variable "snet_3_nsg" {
  type = string
}

variable "snet_4_name" {
  type = string
}

variable "snet_4_address_space" {
  type = list(string)
}

variable "snet_4_nsg" {
  type = string
}

variable "snet_5_name" {
  type = string
}

variable "snet_5_address_space" {
  type = list(string)
}

variable "snet_5_nsg" {
  type = string
}

variable "snet_6_name" {
  type = string
}

variable "snet_6_address_space" {
  type = list(string)
}

variable "snet_6_nsg" {
  type = string
}

variable "sub1_to_sub2_name" {
  type = string
}

variable "sub2_to_sub1_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "default_node_pool_name" {
  description = "Specifies the name of the default node pool"
  type        = string
}

variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  type        = string
}

variable "default_node_pool_enable_auto_scaling" {
  description = "(Optional) Whether to enable auto-scaler. Defaults to false."
  type        = bool
}
variable "default_node_pool_availability_zones" {
  description = "Specifies the availability zones of the default node pool"
  type        = list(string)
}
variable "default_node_pool_enable_host_encryption" {
  description = "(Optional) Should the nodes in this Node Pool have host encryption enabled? Defaults to false."
  type        = bool
}
variable "default_node_pool_enable_node_public_ip" {
  description = "(Optional) Should each node have a Public IP Address? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
}
variable "default_node_pool_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
}

variable "default_node_pool_os_disk_type" {
  description = "(Optional) The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed. Changing this forces a new resource to be created."
  type        = string
}

variable "default_node_pool_max_count" {
  description = "(Required) The maximum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be greater than or equal to min_count."
  type        = number
}

variable "default_node_pool_min_count" {
  description = "(Required) The minimum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be less than or equal to max_count."
  type        = number
}

variable "default_node_pool_node_count" {
  description = "(Optional) The initial number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be a value in the range min_count - max_count."
  type        = number
}

variable "admin_username" {
  description = "(Required) Specifies the Admin Username for the AKS cluster worker nodes. Changing this forces a new resource to be created."
  type        = string
}

variable "SSH_PUBLIC_KEY" {
  description = "(Required) Specifies the SSH public key used to access the cluster. Changing this forces a new resource to be created."
  type        = string
}

variable "tenant_id" {
  type = string
}

variable "network_dns_service_ip" {
  description = "Specifies the DNS service IP"
  type        = string
}

variable "network_service_cidr" {
  description = "Specifies the service CIDR"
  type        = string
}

variable "network_plugin" {
  description = "Specifies the network plugin of the AKS cluster"
  type        = string
}

