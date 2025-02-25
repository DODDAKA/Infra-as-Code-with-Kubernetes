variable "nic_name" {
  type = string
}

variable "vm_resource_group" {
  type = string
}

variable "vm_location" {
  type = string
}

variable "vm_subnet_id" {
  type = string
}

variable "private_IP_allocation" {
  type= string
}

variable "linux_virtualmachine_name" {
  type = string
}

variable "vm_sku_size" {
  type = string
}

variable "public_ip_address_id" {
  type = string
}

variable "vm_admin_username" {
  type = string
}

variable "vm_admin_password" {
  type = string
}

variable "os_disk_config" {
  type = object({
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}