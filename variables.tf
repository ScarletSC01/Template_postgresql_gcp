// Sección: GCP
variable "PROJECT_ID" {
  type        = string
  description = "ID del proyecto de GCP"
}
variable "REGION" {
  type        = string
  description = "Región de despliegue"
}
variable "ZONE" {
  type        = string
  description = "Zona de despliegue (para instancias single zone)"
}
variable "ENVIRONMENT" {
  type        = string
  description = "Ambiente (e.g., 1-Desarrollo)"
}

// Sección: Type / Instancia
variable "DB_INSTANCE_NAME" {
  type        = string
  description = "Nombre de la instancia de Cloud SQL"
}
variable "DB_AVAILABILITY_TYPE" {
  type        = string
  description = "Disponibilidad (regional o single zone)"
}
variable "DB_VERSION" {
  type        = string
  description = "Versión de PostgreSQL (e.g., POSTGRES_15)"
}
variable "MACHINE_TYPE" {
  type        = string
  description = "Máquina (tier) de la instancia (e.g., db-custom-4-16384)"
}
variable "DB_MAX_CONNECTIONS" {
  type        = string
  description = "Máx conexiones"
}
variable "DB_STORAGE_SIZE" {
  type        = string
  description = "Almacenamiento (GB)"
}
variable "DB_STORAGE_AUTO_RESIZE" {
  type        = string
  description = "Auto-resize (true/false)"
}
variable "DB_STORAGE_TYPE" {
  type        = string
  description = "Tipo de disco (SSD/HDD)"
}
variable "DB_USERNAME" {
  type        = string
  description = "Usuario de la base de datos (e.g., sa-app)"
}
variable "DB_PASSWORD" {
  type        = string
  description = "Password del usuario de la base de datos"
}

// Sección: Redes
variable "DB_VPC_NETWORK" {
  type        = string
  description = "VPC a usar (formato projects/PROJECT_ID/global/networks/NETWORK_NAME)"
}
variable "DB_PRIVATE_IP_ENABLED" {
  type        = string
  description = "Habilitar IP privada (true/false)"
}
variable "DB_PUBLIC_ACCESS_ENABLED" {
  type        = string
  description = "Habilitar acceso público (true/false)"
}
variable "DB_IP_RANGE_ALLOWED" {
  type        = string
  description = "Rangos permitidos (true/false para definir si se configuran o no)"
}

// Sección: Seguridad / Operación
variable "DB_BACKUP_START_TIME" {
  type        = string
  description = "Hora inicio backup (HH:MM)"
}
variable "DB_BACKUP_RETENTION_DAYS" {
  type        = string
  description = "Retención (días)"
}
variable "DB_MAINTENANCE_WINDOW_DAY" {
  type        = string
  description = "Día mantención (1=Lun, 7=Dom)"
}
variable "DB_MAINTENANCE_WINDOW_HOUR" {
  type        = string
  description = "Hora mantención (0-23)"
}
variable "DB_MONITORING_ENABLED" {
  type        = string
  description = "Habilitar Monitoring (true/false)"
}
variable "DB_AUDIT_LOGS_ENABLED" {
  type        = string
  description = "Habilitar Audit logs (true/false)"
}
variable "DB_DELETION_PROTECTION" {
  type        = string
  description = "Protección borrado (true/false)"
}
variable "DB_ENCRYPTION_ENABLED" {
  type        = string
  description = "Encripción (true/false)"
}
variable "ENABLE_CACHE" {
  type        = string
  description = "Habilitar caché (true/false)"
}
variable "CHECK_DELETE" {
  type        = string
  description = "Check delete (variable de control, sin mapeo directo en Cloud SQL)"
}
variable "CREDENTIAL_FILE" {
  type        = string
  description = "Ruta credenciales (JSON)"
}
variable "DB_IAM_ROLE" {
  type        = string
  description = "IAM Role"
}

// Sección: Replica / Failover
variable "DB_FAILOVER_REPLICA_ENABLED" {
  type        = string
  description = "Failover replica (true/false)"
}
variable "DB_READ_REPLICA_ENABLED" {
  type        = string
  description = "Read replica (true/false)"
}
