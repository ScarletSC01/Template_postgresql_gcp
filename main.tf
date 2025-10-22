// Proveedor de Google Cloud
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.PROJECT_ID
  region  = var.REGION
}

// 1. Instancia Principal de Cloud SQL
resource "google_sql_database_instance" "master" {
  project             = var.PROJECT_ID
  database_version    = var.DB_VERSION
  region              = var.REGION
  name                = var.DB_INSTANCE_NAME
  
  // Mapeo directo: 'true' -> true, 'false' -> false
  deletion_protection = var.DB_DELETION_PROTECTION == "true"

  // La zona se establece solo si la disponibilidad es 'single zone'
  zone                = var.DB_AVAILABILITY_TYPE == "single zone" ? var.ZONE : null

  settings {
    tier                   = var.MACHINE_TYPE
    disk_size              = try(tonumber(var.DB_STORAGE_SIZE), 10)
    disk_type              = var.DB_STORAGE_TYPE
    disk_autoresize        = var.DB_STORAGE_AUTO_RESIZE == "true"
    activation_policy      = "ALWAYS"
    // 'regional' habilita alta disponibilidad (failover)
    availability_type      = var.DB_AVAILABILITY_TYPE == "regional" ? "REGIONAL" : "ZONAL"
    max_connections        = try(tonumber(var.DB_MAX_CONNECTIONS), 100)
    
    // Mapeo de ENABLE_CACHE
    data_cache_enabled     = var.ENABLE_CACHE == "true"

    // Configuración de Backup
    backup_configuration {
      enabled              = true // Asumido por DB_BACKUP_ENABLED='true'
      start_time           = var.DB_BACKUP_START_TIME
      location             = var.REGION
      retained_backups     = try(tonumber(var.DB_BACKUP_RETENTION_DAYS), 7)
      point_in_time_recovery_enabled = true
    }

    // Mantenimiento
    maintenance_window {
      day  = try(tonumber(var.DB_MAINTENANCE_WINDOW_DAY), 1)
      hour = try(tonumber(var.DB_MAINTENANCE_WINDOW_HOUR), 0)
    }

    // Configuración de IP/Redes
    ip_configuration {
      ipv4_enabled    = var.DB_PUBLIC_ACCESS_ENABLED == "true"
      
      // La red privada requiere que DB_PRIVATE_IP_ENABLED sea true
      private_network = var.DB_PRIVATE_IP_ENABLED == "true" ? var.DB_VPC_NETWORK : null
      
      // Rangos de IP autorizados para acceso público
      dynamic "authorized_networks" {
        for_each = var.DB_PUBLIC_ACCESS_ENABLED == "true" && var.DB_IP_RANGE_ALLOWED == "true" ? [
          { value = "0.0.0.0/0", name = "all-ipv4" } // Rango por defecto, se puede expandir si es necesario.
        ] : []
        content {
          value = authorized_networks.value.value
          name  = authorized_networks.value.name
        }
      }
    }
    
    // Configuración de Flags
    database_flags {
        name  = "cloudsql.enable_pgaudit"
        value = var.DB_AUDIT_LOGS_ENABLED == "true" ? "on" : "off"
    }
  }
}

// 2. Usuario de la Aplicación
resource "google_sql_user" "app_user" {
  project  = var.PROJECT_ID
  instance = google_sql_database_instance.master.name
  name     = var.DB_USERNAME
  
  // La contraseña se establece solo si la autenticación IAM no está habilitada
  password = var.DB_IAM_ROLE == "" ? var.DB_PASSWORD : null 
}

// 3. Réplica de Lectura (Read Replica) - Condicional
resource "google_sql_database_instance" "read_replica" {
  count = var.DB_READ_REPLICA_ENABLED == "true" ? 1 : 0

  project             = var.PROJECT_ID
  database_version    = var.DB_VERSION
  region              = var.REGION
  name                = "${var.DB_INSTANCE_NAME}-read-replica"
  master_instance_name = google_sql_database_instance.master.name

  settings {
    tier                   = var.MACHINE_TYPE
    disk_size              = try(tonumber(var.DB_STORAGE_SIZE), 10)
    disk_type              = var.DB_STORAGE_TYPE
    disk_autoresize        = var.DB_STORAGE_AUTO_RESIZE == "true"
    activation_policy      = "ALWAYS"
    availability_type      = "ZONAL"
    max_connections        = try(tonumber(var.DB_MAX_CONNECTIONS), 100)
    
    ip_configuration {
      ipv4_enabled    = var.DB_PUBLIC_ACCESS_ENABLED == "true"
      private_network = var.DB_PRIVATE_IP_ENABLED == "true" ? var.DB_VPC_NETWORK : null
    }
  }
}
