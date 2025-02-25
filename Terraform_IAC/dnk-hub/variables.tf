
variable "resource_group_name" {
  type = string
  
  description = "This HUB RG Name"
}

variable "location" {
  type = string
 
  description = "This is HUB location"
}

variable "vnet-cus-hub" {
    type = string
    description = "This HUB VNET"
  
}

variable "GatewaySubnet" {
  type=string
  description = "This is Gatewaysubnet"
}

variable "AzureFirewallSubnet" {
  type = string
  description = "This is Azure FW snet"
}

variable "snet-hub-mgmt-01-cus" {
  type = string
  description = "This HUB MGMT snet"
}

variable "snet-hub-appgw-01-cus" {
  type = string
  description = "This is hub appgw snet"
}

variable "snet-hub-acr-01-cus" {
  type = string
  description = "This is hub acr snet"
}

variable "kv-dnk-hub-cus" {
  type = string
  description = "This is hub key vault"
  
}

variable "app-gw-pip" {
type = string
description = "This is app GW" 
}

variable "app-gw" {
  type = string
  description = "app gw"
}