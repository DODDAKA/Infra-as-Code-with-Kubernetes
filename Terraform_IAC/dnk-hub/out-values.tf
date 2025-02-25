
output "xclient-app-gw-id" {
  #value = azurerm_application_gateway.appgw.id
  value = azurerm_application_gateway.app-gw.id
}

output "appgw-hub-subnet-id" {
  value = module.vnet.snet_id[var.snet-hub-appgw-01-cus]
}