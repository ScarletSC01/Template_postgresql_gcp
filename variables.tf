// CONTROL DE ACCIÓN (Usado solo para lógica interna, si fuera necesario, pero se define para recibir el input)
variable "ACTION" {
  type        = string
  description = "Acción de Terraform a ejecutar: plan, apply, destroy"
}

// GCP
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

// TYPE / INSTANCIA
variable "DB_INSTANCE_NAME" {
  type        = string
  description = "Nombre de la instancia de Cloud SQL"
}
variable "DB_INSTANCE_ID" {
  type        = string
  description = "ID de instancia (No se usa directamente en el recurso)"
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
  default     = "100" // Default para manejo de conversión
}
variable "DB_STORAGE_SIZE" {
  type        = string
  description = "Almacenamiento (GB)"
  default     = "10" // Default para manejo de conversión
}
variable "DB_STORAGE_AUTO_RESIZE" {
  type        = string
  description = "Auto-resize (false/true)"
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

// REDES
variable "DB_VPC_NETWORK" {
  type        = string
  description = "VPC a usar (formato projects/PROJECT_ID/global/networks/NETWORK_NAME)"
}
variable "DB_SUBNET" {
  type        = string
  description = "Subred (No se usa directamente en Cloud SQL)"
}
variable "DB_PUBLIC_ACCESS_ENABLED" {
  type        = string
  description = "Habilitar acceso público (false/true)"
}
variable "DB_PRIVATE_IP_ENABLED" {
  type        = string
  description = "Habilitar IP privada (false/true)"
}
variable "DB_IP_RANGE_ALLOWED" {
  type        = string
  description = "Rangos permitidos (true/false para definir si se configuran o no)"
}

// SEGURIDAD / OPERACIÓN
variable "DB_BACKUP_START_TIME" {
  type        = string
  description = "Hora inicio backup (HH:MM)"
}
variable "DB_BACKUP_RETENTION_DAYS" {
  type        = string
  description = "Retención (días)"
  default     = "7"
}
variable "DB_MAINTENANCE_WINDOW_DAY" {
  type        = string
  description = "Día mantención (1=Lun, 7=Dom)"
  default     = "1"
}
variable "DB_MAINTENANCE_WINDOW_HOUR" {
  type        = string
  description = "Hora mantención (0-23)"
  default     = "0"
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
  description = "Encripción (true/false) - Usado para configurar CMEK si es requerido."
}
variable "ENABLE_CACHE" {
  type        = string
  description = "Habilitar caché (false/true)"
}
variable "CHECK_DELETE" {
  type        = string
  description = "Check delete (variable de control de Jenkins)"
}
variable "CREDENTIAL_FILE" {
  type        = string
  description = "Ruta credenciales (JSON) - No usado directamente en Terraform."
}
variable "DB_IAM_ROLE" {
  type        = string
  description = "IAM Role - Para autenticación de base de datos IAM."
}

// REPLICA / FAILOVER
variable "DB_FAILOVER_REPLICA_ENABLED" {
  type        = string
  description = "Failover replica (false/true) - Se logra con availability_type: REGIONAL"
}
variable "DB_READ_REPLICA_ENABLED" {
  type        = string
  description = "Read replica (false/true)"
}
