variable "virtual_network_name" {
  type = string
  description = "This is VNET name"
}

variable "vnet_resource_group_name" {
  type = string
  description = "This VNET rg name"
}

variable "vnet_address_space" {
  type = list(string)
  description = "This is VNET address space"
}

variable "vnet_location" {
  type = string
  description = "This is VNET Location"
}

variable "subnets" {
  type = map(object({
    name = string
    address_prefixes= list(string)
  }))
}