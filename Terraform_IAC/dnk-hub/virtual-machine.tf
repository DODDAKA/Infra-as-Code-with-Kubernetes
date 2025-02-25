resource "azurerm_public_ip" "jumphostpip" {
  name                = "jumphostpip"
  resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
  location            = azurerm_resource_group.rg-dnk-hub-cus.location
  allocation_method   = "Static"
}

# resource "azurerm_network_interface" "jumphost-hub-mgmt" {
#   name                = "jumphost-${azurerm_resource_group.rg-dnk-hub-cus.name}-nic"
#   location            = azurerm_resource_group.rg-dnk-hub-cus.location
#   resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name

#   ip_configuration {
#     name                          = "internal"
#     #subnet_id                     = azurerm_subnet.snet-hub-mgmt-01-cus.id
#     subnet_id                     = module.vnet.snet_id[var.snet-hub-mgmt-01-cus]
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.jumphostpip.id
#   }
# }

module "vmmodule_jumphost" {
  source = "../modules/VM_module"
  nic_name = "jumphost-${azurerm_resource_group.rg-dnk-hub-cus.name}-nic"
  vm_resource_group = azurerm_resource_group.rg-dnk-hub-cus.name
  vm_location = azurerm_resource_group.rg-dnk-hub-cus.location
  vm_subnet_id = module.vnet.snet_id[var.snet-hub-mgmt-01-cus]
  private_IP_allocation = "Dynamic"
  linux_virtualmachine_name ="hubcusjumphost"
  vm_sku_size = "Standard_F2"
  vm_admin_username = "msradmin"
  vm_admin_password = "msrCosmos12#"
  public_ip_address_id = azurerm_public_ip.jumphostpip.id
  os_disk_config = {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference ={
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# resource "azurerm_linux_virtual_machine" "hubcusjumphost" {
#   name                = "hubcusjumphost"
#   resource_group_name = azurerm_resource_group.rg-dnk-hub-cus.name
#   location            = azurerm_resource_group.rg-dnk-hub-cus.location
#   size                = "Standard_F2"
#   admin_username      = "msradmin"
#   admin_password = "msrCosmos12#"
#   disable_password_authentication=false
#   network_interface_ids = [
#     azurerm_network_interface.jumphost-hub-mgmt.id
#   ]

  

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }

# }


resource "null_resource" "setup_script" {
  depends_on = [module.vmmodule_jumphost]

  # File provisioner: Copy the script to the remote VM
  provisioner "file" {
    source      = "C:/Users/msradmin/Desktop/tf_DODDAKA_prj/dnk-hub/sources/script.sh" # Adjust path as needed
    destination = "/tmp/script.sh"

    connection {
      type        = "ssh"
      user        = "msradmin" #azurerm_linux_virtual_machine.hubcusjumphost.admin_username
      password    = "msrCosmos12#" #azurerm_linux_virtual_machine.hubcusjumphost.admin_password
      host        = azurerm_public_ip.jumphostpip.ip_address
      timeout     = "10m"
    }
  }

  # Remote exec provisioner: Execute the copied script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "bash /tmp/script.sh"
    ]
    connection {
      type        = "ssh"
      user        = "msradmin"#azurerm_linux_virtual_machine.hubcusjumphost.admin_username
      password    = "msrCosmos12#" #azurerm_linux_virtual_machine.hubcusjumphost.admin_password
      host        = azurerm_public_ip.jumphostpip.ip_address
      timeout     = "10m"
    }
  }
}