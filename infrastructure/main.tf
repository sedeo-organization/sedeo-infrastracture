resource "azurerm_resource_group" "res-0" {
  location = "polandcentral"
  name     = "Sedeo"
}
resource "azurerm_container_app" "res-1" {
  container_app_environment_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.App/managedEnvironments/managed-environment-sedeo"
  max_inactive_revisions       = 100
  name                         = "backend-sedeo"
  resource_group_name          = "Sedeo"
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
  identity {
    identity_ids = ["/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.ManagedIdentity/userAssignedIdentities/sedeo-identity"]
    type         = "UserAssigned"
  }
  ingress {
    external_enabled = true
    target_port      = 8080
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
  template {
    max_replicas = 1
    min_replicas = 1
    container {
      cpu    = 0.25
      image  = "sedeo.azurecr.io/sedeo:latest"
      memory = "0.5Gi"
      name   = "backend-sedeo"
      env {
        name        = "SPRING_DATASOURCE_URL"
        secret_name = "spring-datasource-url"
      }
      env {
        name        = "SPRING_DATASOURCE_PASSWORD"
        secret_name = "spring-datasource-password"
      }
      env {
        name        = "SPRING_DATASOURCE_USERNAME"
        secret_name = "spring-datasource-username"
      }
      env {
        name  = "SPRING_PROFILES_ACTIVE"
        value = "prod"
      }
      env {
        name        = "AZURE_CONNECTION_STRING"
        secret_name = "azure-connection-string"
      }
      env {
        name        = "JWT_SECRET_KEY"
        secret_name = "jwt-secret-key"
      }
      env {
        name        = "MAIL_SENDER_ADDRESS"
        secret_name = "mail-sender-address"
      }
      env {
        name        = "FRONTEND_BASE_URL"
        secret_name = "frontend-base-url"
      }
    }
  }
  depends_on = [
    azurerm_container_app_environment.res-2,
    azurerm_user_assigned_identity.res-462,
  ]
}
resource "azurerm_container_app_environment" "res-2" {
  infrastructure_resource_group_name = "ME_managed-environment-sedeo_Sedeo_polandcentral"
  infrastructure_subnet_id           = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Network/virtualNetworks/sedeo-virtual-network/subnets/sedeo-backend-subnet"
  location                           = "polandcentral"
  name                               = "managed-environment-sedeo"
  resource_group_name                = "Sedeo"
  depends_on = [
    azurerm_subnet.res-468,
  ]
}
resource "azurerm_communication_service" "res-3" {
  data_location       = "Europe"
  name                = "sedeo-communication-services"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_email_communication_service" "res-4" {
  data_location       = "Europe"
  name                = "sedeo-emailing"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_email_communication_service_domain" "res-5" {
  domain_management = "AzureManaged"
  email_service_id  = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Communication/emailServices/sedeo-emailing"
  name              = "AzureManagedDomain"
  depends_on = [
    azurerm_email_communication_service.res-4,
  ]
}
resource "azurerm_email_communication_service_domain" "res-6" {
  domain_management = "CustomerManaged"
  email_service_id  = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Communication/emailServices/sedeo-emailing"
  name              = "sedeo.com"
  depends_on = [
    azurerm_email_communication_service.res-4,
  ]
}
resource "azurerm_container_registry" "res-7" {
  admin_enabled       = true
  location            = "polandcentral"
  name                = "sedeo"
  resource_group_name = "Sedeo"
  sku                 = "Basic"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_container_registry_scope_map" "res-8" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write", "repositories/*/content/delete"]
  container_registry_name = "sedeo"
  description             = "Can perform all read, write and delete operations on the registry"
  name                    = "_repositories_admin"
  resource_group_name     = "Sedeo"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-9" {
  actions                 = ["repositories/*/content/read"]
  container_registry_name = "sedeo"
  description             = "Can pull any repository of the registry"
  name                    = "_repositories_pull"
  resource_group_name     = "Sedeo"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-10" {
  actions                 = ["repositories/*/content/read", "repositories/*/metadata/read"]
  container_registry_name = "sedeo"
  description             = "Can perform all read operations on the registry"
  name                    = "_repositories_pull_metadata_read"
  resource_group_name     = "Sedeo"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-11" {
  actions                 = ["repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "sedeo"
  description             = "Can push to any repository of the registry"
  name                    = "_repositories_push"
  resource_group_name     = "Sedeo"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_container_registry_scope_map" "res-12" {
  actions                 = ["repositories/*/metadata/read", "repositories/*/metadata/write", "repositories/*/content/read", "repositories/*/content/write"]
  container_registry_name = "sedeo"
  description             = "Can perform all read and write operations on the registry"
  name                    = "_repositories_push_metadata_write"
  resource_group_name     = "Sedeo"
  depends_on = [
    azurerm_container_registry.res-7,
  ]
}
resource "azurerm_postgresql_flexible_server" "res-13" {
  location                      = "polandcentral"
  name                          = "sedeo-postgresql-db"
  public_network_access_enabled = false
  resource_group_name           = "Sedeo"
  zone                          = "1"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-14" {
  name      = "DateStyle"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "ISO, MDY"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-15" {
  name      = "IntervalStyle"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "postgres"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-16" {
  name      = "TimeZone"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "UTC"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-17" {
  name      = "allow_in_place_tablespaces"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-18" {
  name      = "allow_system_table_mods"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-19" {
  name      = "application_name"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-20" {
  name      = "archive_cleanup_command"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-21" {
  name      = "archive_command"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "BlobLogUpload.sh %f %p"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-22" {
  name      = "archive_library"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-23" {
  name      = "archive_mode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "always"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-24" {
  name      = "archive_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "300"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-25" {
  name      = "array_nulls"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-26" {
  name      = "authentication_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "30"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-27" {
  name      = "auto_explain.log_analyze"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-28" {
  name      = "auto_explain.log_buffers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-29" {
  name      = "auto_explain.log_format"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "text"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-30" {
  name      = "auto_explain.log_level"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "log"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-31" {
  name      = "auto_explain.log_min_duration"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-32" {
  name      = "auto_explain.log_nested_statements"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-33" {
  name      = "auto_explain.log_settings"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-34" {
  name      = "auto_explain.log_timing"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-35" {
  name      = "auto_explain.log_triggers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-36" {
  name      = "auto_explain.log_verbose"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-37" {
  name      = "auto_explain.log_wal"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-38" {
  name      = "auto_explain.sample_rate"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1.0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-39" {
  name      = "autovacuum"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-40" {
  name      = "autovacuum_analyze_scale_factor"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-41" {
  name      = "autovacuum_analyze_threshold"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "50"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-42" {
  name      = "autovacuum_freeze_max_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "200000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-43" {
  name      = "autovacuum_max_workers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "3"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-44" {
  name      = "autovacuum_multixact_freeze_max_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "400000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-45" {
  name      = "autovacuum_naptime"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "60"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-46" {
  name      = "autovacuum_vacuum_cost_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-47" {
  name      = "autovacuum_vacuum_cost_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-48" {
  name      = "autovacuum_vacuum_insert_scale_factor"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-49" {
  name      = "autovacuum_vacuum_insert_threshold"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-50" {
  name      = "autovacuum_vacuum_scale_factor"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-51" {
  name      = "autovacuum_vacuum_threshold"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "50"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-52" {
  name      = "autovacuum_work_mem"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-53" {
  name      = "azure.accepted_password_auth_method"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "md5,scram-sha-256"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-54" {
  name      = "azure.enable_temp_tablespaces_on_local_ssd"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-55" {
  name      = "azure.extensions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-56" {
  name      = "azure.migration_copy_with_binary"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-57" {
  name      = "azure.migration_skip_analyze"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-58" {
  name      = "azure.migration_skip_extensions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-59" {
  name      = "azure.migration_skip_large_objects"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-60" {
  name      = "azure.migration_skip_role_user"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-61" {
  name      = "azure.migration_table_split_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "20480"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-62" {
  name      = "azure.single_to_flex_migration"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-63" {
  name      = "azure_cdc.change_batch_buffer_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "16"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-64" {
  name      = "azure_cdc.change_batch_export_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "30"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-65" {
  name      = "azure_cdc.max_snapshot_workers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "3"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-66" {
  name      = "azure_cdc.parquet_compression"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "zstd"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-67" {
  name      = "azure_cdc.snapshot_buffer_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-68" {
  name      = "azure_cdc.snapshot_export_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "180"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-69" {
  name      = "azure_storage.allow_network_access"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-70" {
  name      = "azure_storage.blob_block_size_mb"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "128"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-71" {
  name      = "azure_storage.public_account_access"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-72" {
  name      = "backend_flush_after"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "256"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-73" {
  name      = "backslash_quote"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "safe_encoding"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-74" {
  name      = "backtrace_functions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-75" {
  name      = "bgwriter_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "20"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-76" {
  name      = "bgwriter_flush_after"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "64"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-77" {
  name      = "bgwriter_lru_maxpages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "100"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-78" {
  name      = "bgwriter_lru_multiplier"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-79" {
  name      = "block_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "8192"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-80" {
  name      = "bonjour"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-81" {
  name      = "bonjour_name"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-82" {
  name      = "bytea_output"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "hex"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-83" {
  name      = "check_function_bodies"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-84" {
  name      = "checkpoint_completion_target"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.9"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-85" {
  name      = "checkpoint_flush_after"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "32"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-86" {
  name      = "checkpoint_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "600"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-87" {
  name      = "checkpoint_warning"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "30"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-88" {
  name      = "client_connection_check_interval"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-89" {
  name      = "client_encoding"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "UTF8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-90" {
  name      = "client_min_messages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "notice"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-91" {
  name      = "cluster_name"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-92" {
  name      = "commit_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-93" {
  name      = "commit_siblings"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "5"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-94" {
  name      = "compute_query_id"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "auto"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-95" {
  name      = "config_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/datadrive/pg/data/postgresql.conf"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-96" {
  name      = "connection_throttle.bucket_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-97" {
  name      = "connection_throttle.enable"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-98" {
  name      = "connection_throttle.factor_bias"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-99" {
  name      = "connection_throttle.hash_entries_max"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "500"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-100" {
  name      = "connection_throttle.reset_time"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "120"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-101" {
  name      = "connection_throttle.restore_factor"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-102" {
  name      = "connection_throttle.update_time"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "20"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-103" {
  name      = "constraint_exclusion"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "partition"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-104" {
  name      = "cpu_index_tuple_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.005"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-105" {
  name      = "cpu_operator_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.0025"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-106" {
  name      = "cpu_tuple_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.01"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-107" {
  name      = "cron.database_name"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "postgres"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-108" {
  name      = "cron.log_run"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-109" {
  name      = "cron.log_statement"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-110" {
  name      = "cron.max_running_jobs"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "32"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-111" {
  name      = "cursor_tuple_fraction"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-112" {
  name      = "data_checksums"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-113" {
  name      = "data_directory"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/datadrive/pg/data"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-114" {
  name      = "data_directory_mode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0700"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-115" {
  name      = "data_sync_retry"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-116" {
  name      = "db_user_namespace"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-117" {
  name      = "deadlock_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-118" {
  name      = "debug_assertions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-119" {
  name      = "debug_discard_caches"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-120" {
  name      = "debug_parallel_query"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-121" {
  name      = "debug_pretty_print"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-122" {
  name      = "debug_print_parse"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-123" {
  name      = "debug_print_plan"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-124" {
  name      = "debug_print_rewritten"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-125" {
  name      = "default_statistics_target"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "100"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-126" {
  name      = "default_table_access_method"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "heap"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-127" {
  name      = "default_tablespace"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-128" {
  name      = "default_text_search_config"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "pg_catalog.english"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-129" {
  name      = "default_toast_compression"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "pglz"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-130" {
  name      = "default_transaction_deferrable"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-131" {
  name      = "default_transaction_isolation"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "read committed"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-132" {
  name      = "default_transaction_read_only"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-133" {
  name      = "dynamic_library_path"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "$libdir"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-134" {
  name      = "dynamic_shared_memory_type"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "posix"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-135" {
  name      = "effective_cache_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "229376"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-136" {
  name      = "effective_io_concurrency"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-137" {
  name      = "enable_async_append"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-138" {
  name      = "enable_bitmapscan"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-139" {
  name      = "enable_gathermerge"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-140" {
  name      = "enable_hashagg"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-141" {
  name      = "enable_hashjoin"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-142" {
  name      = "enable_incremental_sort"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-143" {
  name      = "enable_indexonlyscan"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-144" {
  name      = "enable_indexscan"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-145" {
  name      = "enable_material"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-146" {
  name      = "enable_memoize"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-147" {
  name      = "enable_mergejoin"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-148" {
  name      = "enable_nestloop"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-149" {
  name      = "enable_parallel_append"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-150" {
  name      = "enable_parallel_hash"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-151" {
  name      = "enable_partition_pruning"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-152" {
  name      = "enable_partitionwise_aggregate"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-153" {
  name      = "enable_partitionwise_join"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-154" {
  name      = "enable_seqscan"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-155" {
  name      = "enable_sort"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-156" {
  name      = "enable_tidscan"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-157" {
  name      = "escape_string_warning"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-158" {
  name      = "event_source"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "PostgreSQL"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-159" {
  name      = "exit_on_error"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-160" {
  name      = "external_pid_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-161" {
  name      = "extra_float_digits"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-162" {
  name      = "from_collapse_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-163" {
  name      = "fsync"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-164" {
  name      = "full_page_writes"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-165" {
  name      = "geqo"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-166" {
  name      = "geqo_effort"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "5"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-167" {
  name      = "geqo_generations"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-168" {
  name      = "geqo_pool_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-169" {
  name      = "geqo_seed"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-170" {
  name      = "geqo_selection_bias"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-171" {
  name      = "geqo_threshold"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "12"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-172" {
  name      = "gin_fuzzy_search_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-173" {
  name      = "gin_pending_list_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "4096"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-174" {
  name      = "hash_mem_multiplier"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-175" {
  name      = "hba_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/datadrive/pg/data/pg_hba.conf"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-176" {
  name      = "hot_standby"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-177" {
  name      = "hot_standby_feedback"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-178" {
  name      = "huge_page_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-179" {
  name      = "huge_pages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "try"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-180" {
  name      = "ident_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/datadrive/pg/data/pg_ident.conf"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-181" {
  name      = "idle_in_transaction_session_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-182" {
  name      = "idle_session_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-183" {
  name      = "ignore_checksum_failure"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-184" {
  name      = "ignore_invalid_pages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-185" {
  name      = "ignore_system_indexes"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-186" {
  name      = "in_hot_standby"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-187" {
  name      = "integer_datetimes"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-188" {
  name      = "intelligent_tuning"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-189" {
  name      = "intelligent_tuning.metric_targets"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "none"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-190" {
  name      = "jit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-191" {
  name      = "jit_above_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "100000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-192" {
  name      = "jit_debugging_support"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-193" {
  name      = "jit_dump_bitcode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-194" {
  name      = "jit_expressions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-195" {
  name      = "jit_inline_above_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "500000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-196" {
  name      = "jit_optimize_above_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "500000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-197" {
  name      = "jit_profiling_support"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-198" {
  name      = "jit_provider"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "llvmjit"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-199" {
  name      = "jit_tuple_deforming"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-200" {
  name      = "join_collapse_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-201" {
  name      = "krb_caseins_users"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-202" {
  name      = "krb_server_keyfile"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-203" {
  name      = "lc_messages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "en_US.utf8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-204" {
  name      = "lc_monetary"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "en_US.utf-8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-205" {
  name      = "lc_numeric"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "en_US.utf-8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-206" {
  name      = "lc_time"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "en_US.utf8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-207" {
  name      = "listen_addresses"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "*"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-208" {
  name      = "lo_compat_privileges"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-209" {
  name      = "local_preload_libraries"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-210" {
  name      = "lock_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-211" {
  name      = "log_autovacuum_min_duration"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "600000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-212" {
  name      = "log_checkpoints"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-213" {
  name      = "log_connections"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-214" {
  name      = "log_destination"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "stderr"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-215" {
  name      = "log_directory"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "log"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-216" {
  name      = "log_disconnections"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-217" {
  name      = "log_duration"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-218" {
  name      = "log_error_verbosity"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "default"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-219" {
  name      = "log_executor_stats"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-220" {
  name      = "log_file_mode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0600"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-221" {
  name      = "log_filename"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "postgresql-%Y-%m-%d_%H%M%S.log"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-222" {
  name      = "log_hostname"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-223" {
  name      = "log_line_prefix"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "%t-%c-"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-224" {
  name      = "log_lock_waits"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-225" {
  name      = "log_min_duration_sample"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-226" {
  name      = "log_min_duration_statement"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-227" {
  name      = "log_min_error_statement"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "error"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-228" {
  name      = "log_min_messages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "warning"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-229" {
  name      = "log_parameter_max_length"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-230" {
  name      = "log_parameter_max_length_on_error"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-231" {
  name      = "log_parser_stats"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-232" {
  name      = "log_planner_stats"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-233" {
  name      = "log_recovery_conflict_waits"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-234" {
  name      = "log_replication_commands"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-235" {
  name      = "log_rotation_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "60"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-236" {
  name      = "log_rotation_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "102400"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-237" {
  name      = "log_startup_progress_interval"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-238" {
  name      = "log_statement"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "none"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-239" {
  name      = "log_statement_sample_rate"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-240" {
  name      = "log_statement_stats"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-241" {
  name      = "log_temp_files"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-242" {
  name      = "log_timezone"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "UTC"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-243" {
  name      = "log_transaction_sample_rate"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-244" {
  name      = "log_truncate_on_rotation"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-245" {
  name      = "logfiles.download_enable"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-246" {
  name      = "logfiles.retention_days"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "3"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-247" {
  name      = "logging_collector"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-248" {
  name      = "logical_decoding_work_mem"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "65536"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-249" {
  name      = "maintenance_io_concurrency"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-250" {
  name      = "maintenance_work_mem"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "99328"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-251" {
  name      = "max_connections"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "50"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-252" {
  name      = "max_files_per_process"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-253" {
  name      = "max_function_args"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "100"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-254" {
  name      = "max_identifier_length"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "63"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-255" {
  name      = "max_index_keys"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "32"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-256" {
  name      = "max_locks_per_transaction"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "64"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-257" {
  name      = "max_logical_replication_workers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "4"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-258" {
  name      = "max_parallel_apply_workers_per_subscription"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-259" {
  name      = "max_parallel_maintenance_workers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-260" {
  name      = "max_parallel_workers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-261" {
  name      = "max_parallel_workers_per_gather"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-262" {
  name      = "max_pred_locks_per_page"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-263" {
  name      = "max_pred_locks_per_relation"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-264" {
  name      = "max_pred_locks_per_transaction"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "64"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-265" {
  name      = "max_prepared_transactions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-266" {
  name      = "max_replication_slots"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-267" {
  name      = "max_slot_wal_keep_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-268" {
  name      = "max_stack_depth"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2048"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-269" {
  name      = "max_standby_archive_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "30000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-270" {
  name      = "max_standby_streaming_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "30000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-271" {
  name      = "max_sync_workers_per_subscription"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-272" {
  name      = "max_wal_senders"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-273" {
  name      = "max_wal_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2048"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-274" {
  name      = "max_worker_processes"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-275" {
  name      = "metrics.autovacuum_diagnostics"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-276" {
  name      = "metrics.collector_database_activity"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-277" {
  name      = "metrics.pgbouncer_diagnostics"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-278" {
  name      = "min_dynamic_shared_memory"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-279" {
  name      = "min_parallel_index_scan_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "64"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-280" {
  name      = "min_parallel_table_scan_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1024"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-281" {
  name      = "min_wal_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "80"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-282" {
  name      = "parallel_leader_participation"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-283" {
  name      = "parallel_setup_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-284" {
  name      = "parallel_tuple_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0.1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-285" {
  name      = "password_encryption"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "scram-sha-256"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-286" {
  name      = "pg_partman_bgw.analyze"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-287" {
  name      = "pg_partman_bgw.dbname"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-288" {
  name      = "pg_partman_bgw.interval"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "3600"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-289" {
  name      = "pg_partman_bgw.jobmon"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-290" {
  name      = "pg_partman_bgw.role"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-291" {
  name      = "pg_qs.interval_length_minutes"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "15"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-292" {
  name      = "pg_qs.is_enabled_fs"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-293" {
  name      = "pg_qs.max_plan_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "7500"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-294" {
  name      = "pg_qs.max_query_text_length"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "6000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-295" {
  name      = "pg_qs.parameters_capture_mode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "capture_parameterless_only"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-296" {
  name      = "pg_qs.query_capture_mode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "none"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-297" {
  name      = "pg_qs.retention_period_in_days"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "7"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-298" {
  name      = "pg_qs.store_query_plans"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-299" {
  name      = "pg_qs.track_utility"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-300" {
  name      = "pg_stat_statements.max"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "5000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-301" {
  name      = "pg_stat_statements.save"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-302" {
  name      = "pg_stat_statements.track"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "none"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-303" {
  name      = "pg_stat_statements.track_utility"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-304" {
  name      = "pgaudit.log"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "none"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-305" {
  name      = "pgaudit.log_catalog"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-306" {
  name      = "pgaudit.log_client"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-307" {
  name      = "pgaudit.log_level"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "log"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-308" {
  name      = "pgaudit.log_parameter"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-309" {
  name      = "pgaudit.log_relation"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-310" {
  name      = "pgaudit.log_statement_once"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-311" {
  name      = "pgaudit.role"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-312" {
  name      = "pglogical.batch_inserts"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-313" {
  name      = "pglogical.conflict_log_level"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "log"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-314" {
  name      = "pglogical.conflict_resolution"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "apply_remote"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-315" {
  name      = "pglogical.use_spi"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-316" {
  name      = "pgms_stats.is_enabled_fs"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-317" {
  name      = "pgms_wait_sampling.history_period"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "100"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-318" {
  name      = "pgms_wait_sampling.is_enabled_fs"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-319" {
  name      = "pgms_wait_sampling.query_capture_mode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "none"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-320" {
  name      = "plan_cache_mode"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "auto"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-321" {
  name      = "port"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "5432"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-322" {
  name      = "post_auth_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-323" {
  name      = "postgis.gdal_enabled_drivers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "DISABLE_ALL"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-324" {
  name      = "pre_auth_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-325" {
  name      = "primary_conninfo"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-326" {
  name      = "primary_slot_name"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-327" {
  name      = "quote_all_identifiers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-328" {
  name      = "random_page_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-329" {
  name      = "recovery_end_command"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-330" {
  name      = "recovery_init_sync_method"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "fsync"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-331" {
  name      = "recovery_min_apply_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-332" {
  name      = "recovery_prefetch"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "try"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-333" {
  name      = "recovery_target"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-334" {
  name      = "recovery_target_action"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "pause"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-335" {
  name      = "recovery_target_inclusive"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-336" {
  name      = "recovery_target_lsn"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-337" {
  name      = "recovery_target_name"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-338" {
  name      = "recovery_target_time"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-339" {
  name      = "recovery_target_timeline"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "latest"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-340" {
  name      = "recovery_target_xid"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-341" {
  name      = "recursive_worktable_factor"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-342" {
  name      = "remove_temp_files_after_crash"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-343" {
  name      = "require_secure_transport"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-344" {
  name      = "reserved_connections"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "5"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-345" {
  name      = "restart_after_crash"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-346" {
  name      = "restore_command"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-347" {
  name      = "row_security"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-348" {
  name      = "search_path"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "\"$user\", public"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-349" {
  name      = "segment_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "131072"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-350" {
  name      = "seq_page_cost"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-351" {
  name      = "server_encoding"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "UTF8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-352" {
  name      = "server_version"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "16.8"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-353" {
  name      = "server_version_num"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "160008"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-354" {
  name      = "session_preload_libraries"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-355" {
  name      = "session_replication_role"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "origin"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-356" {
  name      = "shared_buffers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "32768"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-357" {
  name      = "shared_memory_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "302"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-358" {
  name      = "shared_memory_size_in_huge_pages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "151"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-359" {
  name      = "shared_memory_type"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "mmap"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-360" {
  name      = "shared_preload_libraries"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "pg_cron,pg_stat_statements"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-361" {
  name      = "ssl"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-362" {
  name      = "ssl_ca_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/datadrive/certs/ca.pem"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-363" {
  name      = "ssl_cert_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/datadrive/certs/cert.pem"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-364" {
  name      = "ssl_ciphers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-365" {
  name      = "ssl_crl_dir"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-366" {
  name      = "ssl_crl_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-367" {
  name      = "ssl_dh_params_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-368" {
  name      = "ssl_ecdh_curve"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "prime256v1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-369" {
  name      = "ssl_key_file"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/datadrive/certs/key.pem"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-370" {
  name      = "ssl_library"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "OpenSSL"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-371" {
  name      = "ssl_max_protocol_version"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-372" {
  name      = "ssl_min_protocol_version"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "TLSv1.2"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-373" {
  name      = "ssl_passphrase_command"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-374" {
  name      = "ssl_passphrase_command_supports_reload"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-375" {
  name      = "ssl_prefer_server_ciphers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-376" {
  name      = "standard_conforming_strings"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-377" {
  name      = "statement_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-378" {
  name      = "stats_fetch_consistency"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "cache"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-379" {
  name      = "superuser_reserved_connections"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-380" {
  name      = "synchronize_seqscans"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-381" {
  name      = "synchronous_commit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-382" {
  name      = "synchronous_standby_names"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-383" {
  name      = "syslog_facility"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "local0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-384" {
  name      = "syslog_ident"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "postgres"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-385" {
  name      = "syslog_sequence_numbers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-386" {
  name      = "syslog_split_messages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-387" {
  name      = "tcp_keepalives_count"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "9"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-388" {
  name      = "tcp_keepalives_idle"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "120"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-389" {
  name      = "tcp_keepalives_interval"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "30"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-390" {
  name      = "tcp_user_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-391" {
  name      = "temp_buffers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1024"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-392" {
  name      = "temp_file_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "-1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-393" {
  name      = "temp_tablespaces"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-394" {
  name      = "timezone_abbreviations"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "Default"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-395" {
  name      = "trace_notify"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-396" {
  name      = "trace_recovery_messages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "log"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-397" {
  name      = "trace_sort"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-398" {
  name      = "track_activities"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-399" {
  name      = "track_activity_query_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1024"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-400" {
  name      = "track_commit_timestamp"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-401" {
  name      = "track_counts"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-402" {
  name      = "track_functions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "none"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-403" {
  name      = "track_io_timing"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-404" {
  name      = "track_wal_io_timing"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-405" {
  name      = "transaction_deferrable"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-406" {
  name      = "transaction_isolation"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "read committed"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-407" {
  name      = "transaction_read_only"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-408" {
  name      = "transform_null_equals"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-409" {
  name      = "unix_socket_directories"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "/tmp,/tmp/tuning_sockets"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-410" {
  name      = "unix_socket_group"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-411" {
  name      = "unix_socket_permissions"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0777"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-412" {
  name      = "update_process_title"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-413" {
  name      = "vacuum_buffer_usage_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "256"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-414" {
  name      = "vacuum_cost_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-415" {
  name      = "vacuum_cost_limit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "200"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-416" {
  name      = "vacuum_cost_page_dirty"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "20"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-417" {
  name      = "vacuum_cost_page_hit"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-418" {
  name      = "vacuum_cost_page_miss"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-419" {
  name      = "vacuum_failsafe_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1600000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-420" {
  name      = "vacuum_freeze_min_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "50000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-421" {
  name      = "vacuum_freeze_table_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "150000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-422" {
  name      = "vacuum_multixact_failsafe_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "1600000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-423" {
  name      = "vacuum_multixact_freeze_min_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "5000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-424" {
  name      = "vacuum_multixact_freeze_table_age"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "150000000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-425" {
  name      = "wal_block_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "8192"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-426" {
  name      = "wal_buffers"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2048"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-427" {
  name      = "wal_compression"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-428" {
  name      = "wal_consistency_checking"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-429" {
  name      = "wal_decode_buffer_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "524288"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-430" {
  name      = "wal_init_zero"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-431" {
  name      = "wal_keep_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "400"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-432" {
  name      = "wal_level"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "replica"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-433" {
  name      = "wal_log_hints"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-434" {
  name      = "wal_receiver_create_temp_slot"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-435" {
  name      = "wal_receiver_status_interval"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "10"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-436" {
  name      = "wal_receiver_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "60000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-437" {
  name      = "wal_recycle"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "on"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-438" {
  name      = "wal_retrieve_retry_interval"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "5000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-439" {
  name      = "wal_segment_size"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "16777216"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-440" {
  name      = "wal_sender_timeout"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "60000"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-441" {
  name      = "wal_skip_threshold"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "2048"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-442" {
  name      = "wal_sync_method"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "fdatasync"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-443" {
  name      = "wal_writer_delay"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "200"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-444" {
  name      = "wal_writer_flush_after"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "128"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-445" {
  name      = "work_mem"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "4096"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-446" {
  name      = "xmlbinary"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "base64"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-447" {
  name      = "xmloption"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "content"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_configuration" "res-448" {
  name      = "zero_damaged_pages"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  value     = "off"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_database" "res-449" {
  name      = "azure_maintenance"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_database" "res-450" {
  name      = "azure_sys"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_database" "res-451" {
  name      = "postgres"
  server_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_firewall_rule" "res-452" {
  end_ip_address   = "0.0.0.0"
  name             = "AllowAllAzureServicesAndResourcesWithinAzureIps_2025-3-23_3-9-52"
  server_id        = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  start_ip_address = "0.0.0.0"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_postgresql_flexible_server_firewall_rule" "res-453" {
  end_ip_address   = "83.29.112.114"
  name             = "ClientIPAddress_2025-3-23_2-55-46"
  server_id        = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
  start_ip_address = "83.29.112.114"
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
  ]
}
resource "azurerm_key_vault" "res-454" {
  location                   = "polandcentral"
  name                       = "sedeo-vault"
  resource_group_name        = "Sedeo"
  sku_name                   = "standard"
  soft_delete_retention_days = 15
  tenant_id                  = "67ea5955-9b5c-4693-a8f9-960f2a3b49bb"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_user_assigned_identity" "res-462" {
  location            = "polandcentral"
  name                = "sedeo-identity"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_private_dns_zone" "res-463" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-464" {
  name                  = "4tkkell2mpad4"
  private_dns_zone_name = "privatelink.postgres.database.azure.com"
  resource_group_name   = "Sedeo"
  virtual_network_id    = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Network/virtualNetworks/sedeo-virtual-network"
  depends_on = [
    azurerm_private_dns_zone.res-463,
    azurerm_virtual_network.res-467,
  ]
}
resource "azurerm_private_endpoint" "res-465" {
  custom_network_interface_name = "db-private-endpoint-nic"
  location                      = "polandcentral"
  name                          = "db-private-endpoint"
  resource_group_name           = "Sedeo"
  subnet_id                     = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Network/virtualNetworks/sedeo-virtual-network/subnets/sedeo-db-subnet"
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.Network/privateDnsZones/privatelink.postgres.database.azure.com"]
  }
  private_service_connection {
    name                           = "db-private-endpoint"
    private_connection_resource_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.DBforPostgreSQL/flexibleServers/sedeo-postgresql-db"
    subresource_names              = ["postgresqlServer"]
  }
  depends_on = [
    azurerm_postgresql_flexible_server.res-13,
    azurerm_private_dns_zone.res-463,
    azurerm_subnet.res-469,
  ]
}
resource "azurerm_virtual_network" "res-467" {
  address_space       = ["10.0.0.0/16"]
  location            = "polandcentral"
  name                = "sedeo-virtual-network"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_subnet" "res-468" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "sedeo-backend-subnet"
  resource_group_name  = "Sedeo"
  virtual_network_name = "sedeo-virtual-network"
  delegation {
    name = "Microsoft.App.environments"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.App/environments"
    }
  }
  depends_on = [
    azurerm_virtual_network.res-467,
  ]
}
resource "azurerm_subnet" "res-469" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "sedeo-db-subnet"
  resource_group_name  = "Sedeo"
  virtual_network_name = "sedeo-virtual-network"
  depends_on = [
    azurerm_virtual_network.res-467,
  ]
}
resource "azurerm_subnet" "res-470" {
  address_prefixes     = ["10.0.2.0/24"]
  name                 = "sedeo-load-balancer-subnet"
  resource_group_name  = "Sedeo"
  virtual_network_name = "sedeo-virtual-network"
  depends_on = [
    azurerm_virtual_network.res-467,
  ]
}
resource "azurerm_log_analytics_workspace" "res-471" {
  location            = "polandcentral"
  name                = "sedeo-logs"
  resource_group_name = "Sedeo"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-472" {
  category                   = "General Exploration"
  display_name               = "All Computers with their most recent data"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_General|AlphabeticallySortedComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-473" {
  category                   = "General Exploration"
  display_name               = "Stale Computers (data older than 24 hours)"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_General|StaleComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-474" {
  category                   = "General Exploration"
  display_name               = "Which Management Group is generating the most data points?"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_General|dataPointsPerManagementGroup"
  query                      = "search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-475" {
  category                   = "General Exploration"
  display_name               = "Distribution of data Types"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_General|dataTypeDistribution"
  query                      = "search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-476" {
  category                   = "Log Management"
  display_name               = "All Events"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|AllEvents"
  query                      = "Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-477" {
  category                   = "Log Management"
  display_name               = "All Syslogs"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|AllSyslog"
  query                      = "Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-478" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by Facility"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|AllSyslogByFacility"
  query                      = "Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-479" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by ProcessName"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|AllSyslogByProcessName"
  query                      = "Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-480" {
  category                   = "Log Management"
  display_name               = "All Syslog Records with Errors"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|AllSyslogsWithErrors"
  query                      = "Syslog | where SeverityLevel == \"error\" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-481" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-482" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by HTTP Method"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-483" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|CountIISLogEntriesClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-484" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP Request Method"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-485" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP User Agent"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-486" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Host requested by client"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-487" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL for the host \"www.contoso.com\" (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|CountOfIISLogEntriesByURLForHost"
  query                      = "search csHost == \"www.contoso.com\" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost=\"www.contoso.com\" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-488" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL requested by client (without query strings)"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-489" {
  category                   = "Log Management"
  display_name               = "Count of Events with level \"Warning\" grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|CountOfWarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-490" {
  category                   = "Log Management"
  display_name               = "Shows breakdown of response codes"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|DisplayBreakdownRespondCodes"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-491" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Log"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|EventsByEventLog"
  query                      = "Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-492" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Source"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|EventsByEventSource"
  query                      = "Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-493" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|EventsByEventsID"
  query                      = "Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-494" {
  category                   = "Log Management"
  display_name               = "Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|EventsInOMBetween2000to3000"
  query                      = "Event | where EventLog == \"Operations Manager\" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Operations Manager\" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-495" {
  category                   = "Log Management"
  display_name               = "Count of Events containing the word \"started\" grouped by EventID"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|EventsWithStartedinEventID"
  query                      = "search in (Event) \"started\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event \"started\" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-496" {
  category                   = "Log Management"
  display_name               = "Find the maximum time taken for each page"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|FindMaximumTimeTakenForEachPage"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-497" {
  category                   = "Log Management"
  display_name               = "IIS Log Entries for a specific client IP Address (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|IISLogEntriesForClientIP"
  query                      = "search cIP == \"192.168.0.1\" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP=\"192.168.0.1\" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-498" {
  category                   = "Log Management"
  display_name               = "All IIS Log Entries"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|ListAllIISLogEntries"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-499" {
  category                   = "Log Management"
  display_name               = "How many connections to Operations Manager's SDK service by day"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|NoOfConnectionsToOMSDKService"
  query                      = "Event | where EventID == 26328 and EventLog == \"Operations Manager\" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog=\"Operations Manager\" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-500" {
  category                   = "Log Management"
  display_name               = "When did my servers initiate restart?"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|ServerRestartTime"
  query                      = "search in (Event) \"shutdown\" and EventLog == \"System\" and Source == \"User32\" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-501" {
  category                   = "Log Management"
  display_name               = "Shows which pages people are getting a 404 for"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|Show404PagesList"
  query                      = "search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-502" {
  category                   = "Log Management"
  display_name               = "Shows servers that are throwing internal server error"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|ShowServersThrowingInternalServerError"
  query                      = "search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-503" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each Azure Role Instance"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-504" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each IIS Computer"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|TotalBytesReceivedByEachIISComputer"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-505" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-506" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by each IIS ServerIP Address"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-507" {
  category                   = "Log Management"
  display_name               = "Total Bytes sent by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|TotalBytesSentByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-508" {
  category                   = "Log Management"
  display_name               = "All Events with level \"Warning\""
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|WarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-509" {
  category                   = "Log Management"
  display_name               = "Windows Firewall Policy settings have changed"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|WindowsFireawallPolicySettingsChanged"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-510" {
  category                   = "Log Management"
  display_name               = "On which machines and how many times have Windows Firewall Policy settings changed"
  log_analytics_workspace_id = "/subscriptions/f8e07220-9b66-4b1a-aa51-c3d502f6f806/resourceGroups/Sedeo/providers/Microsoft.OperationalInsights/workspaces/sedeo-logs"
  name                       = "LogManagement(sedeo-logs)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-471,
  ]
}
resource "azurerm_private_dns_a_record" "res-1065" {
  name                = "sedeo-postgresql-db"
  records             = ["10.0.1.4"]
  resource_group_name = "sedeo"
  tags = {
    creator = "created by private endpoint db-private-endpoint with resource guid 0bbf6f7b-f5e3-4fec-a954-f909dc67c48e"
  }
  ttl       = 10
  zone_name = "privatelink.postgres.database.azure.com"
  depends_on = [
    azurerm_private_dns_zone.res-463,
  ]
}
