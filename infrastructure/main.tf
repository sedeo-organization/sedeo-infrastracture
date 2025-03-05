resource "azurerm_resource_group" "res-0" {
  location = "polandcentral"
  name     = "Sedeo"
}
resource "azurerm_communication_service" "res-1" {
  data_location       = "Europe"
  name                = "sedeo-communication-services"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_email_communication_service" "res-2" {
  data_location       = "Europe"
  name                = "sedeo-emailing"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_email_communication_service_domain" "res-3" {
  domain_management = "AzureManaged"
  email_service_id  = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Communication/emailServices/sedeo-emailing"
  name              = "AzureManagedDomain"
  depends_on = [
    azurerm_email_communication_service.res-2,
  ]
}
resource "azurerm_email_communication_service_domain" "res-4" {
  domain_management = "CustomerManaged"
  email_service_id  = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Communication/emailServices/sedeo-emailing"
  name              = "sedeo.com"
  depends_on = [
    azurerm_email_communication_service.res-2,
  ]
}
