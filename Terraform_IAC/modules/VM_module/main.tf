resource "azurerm_network_interface" "nicmodule" {
  name                = var.nic_name
  location            = var.vm_location
  resource_group_name = var.vm_resource_group

  ip_configuration {
    name                          = "${var.linux_virtualmachine_name}-internal"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = var.private_IP_allocation
    public_ip_address_id =var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "linuxvmmodule" {
  name                =var.linux_virtualmachine_name
  resource_group_name = var.vm_resource_group
  location            = var.vm_location
  size               = var.vm_sku_size
  admin_username      = var.vm_admin_username
  network_interface_ids = [
    azurerm_network_interface.nicmodule.id
  ]

  admin_password = var.vm_admin_password
  disable_password_authentication = false

  os_disk {
    caching              = var.os_disk_config.caching
    storage_account_type = var.os_disk_config.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
}