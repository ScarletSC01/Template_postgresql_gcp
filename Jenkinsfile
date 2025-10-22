pipeline {
  agent any

  environment {
    DB_ENGINE            = 'PostgreSQL'
    DB_PASSWORD_ADMIN    = 'password'
    DB_PLATFORM_PASS     = 'password'
    DB_PLATFORM_USER     = 'equipo_plataforma'
    DB_RESOURCE_LABELS   = 'test'
    DB_SERVICE_PROVIDER  = 'GCP - Cloud SQL'
    DB_TAGS              = 'test'
    DB_TIME_ZONE         = 'GMT-4'
    DB_USER_ADMIN        = 'postgres'
    DB_BACKUP_ENABLED    = 'true'
    PAIS                 = 'CL'
  }

  parameters {
    // GCP
    string(name: 'PROJECT_ID', defaultValue: '', description: 'ID del proyecto')
    string(name: 'REGION',     defaultValue: '', description: 'Región')
    string(name: 'ZONE',       defaultValue: '', description: 'Zona')
    choice(name: 'ENVIRONMENT', choices: ['1-Desarrollo', '2-Pre-productivo (PP)', '3-Produccion'], description: 'Ambiente')

    // TYPE / INSTANCIA
    string(name: 'DB_INSTANCE_NAME', defaultValue: '', description: 'Nombre instancia')
    string(name: 'DB_INSTANCE_ID',   defaultValue: '', description: 'ID instancia')
    choice(name: 'DB_AVAILABILITY_TYPE', choices: ['regional', 'single zone'], description: 'Disponibilidad')
    choice(name: 'DB_VERSION',           choices: ['POSTGRES_15', 'POSTGRES_14'], description: 'Versión PostgreSQL')
    choice(name: 'MACHINE_TYPE',         choices: ['db-custom-4-16384', 'standard'], description: 'Máquina')
    string(name: 'DB_MAX_CONNECTIONS',   defaultValue: '', description: 'Máx conexiones')
    string(name: 'DB_STORAGE_SIZE',      defaultValue: '', description: 'Almacenamiento (GB)')
    choice(name: 'DB_STORAGE_AUTO_RESIZE', choices: ['false', 'true'], description: 'Auto-resize')
    choice(name: 'DB_STORAGE_TYPE',        choices: ['SSD', 'HDD'], description: 'Tipo de disco')
    string(name: 'DB_USERNAME', defaultValue: 'sa-app',  description: 'Usuario')
    string(name: 'DB_PASSWORD', defaultValue: 'password', description: 'Password')

    // REDES
    string(name: 'DB_VPC_NETWORK', defaultValue: '', description: 'VPC')
    string(name: 'DB_SUBNET',      defaultValue: '', description: 'Subred')
    choice(name: 'DB_PUBLIC_ACCESS_ENABLED', choices: ['false', 'true'], description: 'Acceso público')
    choice(name: 'DB_PRIVATE_IP_ENABLED',    choices: ['false', 'true'], description: 'IP privada')
    choice(name: 'DB_IP_RANGE_ALLOWED',      choices: ['true', 'false'], description: 'Rangos permitidos')

    // SEGURIDAD / OPERACIÓN
    string(name: 'DB_BACKUP_START_TIME',     defaultValue: '', description: 'Hora inicio backup (HH:MM)')
    string(name: 'DB_BACKUP_RETENTION_DAYS', defaultValue: '', description: 'Retención (días)')
    string(name: 'DB_MAINTENANCE_WINDOW_DAY',  defaultValue: '', description: 'Día mantención')
    string(name: 'DB_MAINTENANCE_WINDOW_HOUR', defaultValue: '', description: 'Hora mantención')
    choice(name: 'DB_MONITORING_ENABLED',   choices: ['true', 'false'], description: 'Monitoring')
    choice(name: 'DB_AUDIT_LOGS_ENABLED',   choices: ['true', 'false'], description: 'Audit logs')
    choice(name: 'CREDENTIAL_FILE',         choices: ['sa-plataforma', 'sa-transacciones'], description: 'Ruta credenciales (JSON)')
    string(name: 'DB_IAM_ROLE',             defaultValue: '', description: 'IAM Role')
    choice(name: 'DB_DELETION_PROTECTION',  choices: ['true', 'false'], description: 'Protección borrado')
    choice(name: 'CHECK_DELETE',            choices: ['true', 'false'], description: 'Check delete')
    choice(name: 'ENABLE_CACHE',            choices: ['false', 'true'], description: 'Habilitar caché (por defecto false)')
    choice(name: 'DB_ENCRYPTION_ENABLED',   choices: ['true', 'false'], description: 'Encripción')

    // REPLICA / FAILOVER
    choice(name: 'DB_FAILOVER_REPLICA_ENABLED', choices: ['false', 'true'], description: 'Failover replica')
    choice(name: 'DB_READ_REPLICA_ENABLED',     choices: ['false', 'true'], description: 'Read replica')
  }

  stages {
    stage('Imprimir variables por sección') {
      steps {
        script {
          // --- Sección: Ocultas (environment)
          def ocultas = [
            DB_BACKUP_ENABLED   : env.DB_BACKUP_ENABLED,
            DB_ENGINE           : env.DB_ENGINE,
            DB_PASSWORD_ADMIN   : env.DB_PASSWORD_ADMIN,
            DB_PLATFORM_PASS    : env.DB_PLATFORM_PASS,
            DB_PLATFORM_USER    : env.DB_PLATFORM_USER,
            DB_RESOURCE_LABELS  : env.DB_RESOURCE_LABELS,
            DB_SERVICE_PROVIDER : env.DB_SERVICE_PROVIDER,
            DB_TAGS             : env.DB_TAGS,
            DB_TIME_ZONE        : env.DB_TIME_ZONE,
            DB_USER_ADMIN       : env.DB_USER_ADMIN,
            PAIS                : env.PAIS
          ]

          // --- Sección: GCP
          def gcp = [
            ENVIRONMENT : params.ENVIRONMENT,
            PROJECT_ID  : params.PROJECT_ID,
            REGION      : params.REGION,
            ZONE        : params.ZONE
          ]

          // --- Sección: Type / Instancia
          def typeInst = [
            DB_AVAILABILITY_TYPE : params.DB_AVAILABILITY_TYPE,
            DB_INSTANCE_ID       : params.DB_INSTANCE_ID,
            DB_INSTANCE_NAME     : params.DB_INSTANCE_NAME,
            DB_MAX_CONNECTIONS   : params.DB_MAX_CONNECTIONS,
            DB_PASSWORD          : params.DB_PASSWORD,
            DB_STORAGE_AUTO_RESIZE: params.DB_STORAGE_AUTO_RESIZE,
            DB_STORAGE_SIZE      : params.DB_STORAGE_SIZE,
            DB_STORAGE_TYPE      : params.DB_STORAGE_TYPE,
            DB_USERNAME          : params.DB_USERNAME,
            DB_VERSION           : params.DB_VERSION,
            MACHINE_TYPE         : params.MACHINE_TYPE
          ]

          // --- Sección: Redes
          def redes = [
            DB_IP_RANGE_ALLOWED      : params.DB_IP_RANGE_ALLOWED,
            DB_PRIVATE_IP_ENABLED    : params.DB_PRIVATE_IP_ENABLED,
            DB_PUBLIC_ACCESS_ENABLED : params.DB_PUBLIC_ACCESS_ENABLED,
            DB_SUBNET                : params.DB_SUBNET,
            DB_VPC_NETWORK           : params.DB_VPC_NETWORK
          ]

          // --- Sección: Seguridad / Operación
          def segOp = [
            CHECK_DELETE               : params.CHECK_DELETE,
            CREDENTIAL_FILE            : params.CREDENTIAL_FILE,
            DB_AUDIT_LOGS_ENABLED      : params.DB_AUDIT_LOGS_ENABLED,
            DB_BACKUP_RETENTION_DAYS   : params.DB_BACKUP_RETENTION_DAYS,
            DB_BACKUP_START_TIME       : params.DB_BACKUP_START_TIME,
            DB_DELETION_PROTECTION     : params.DB_DELETION_PROTECTION,
            DB_ENCRYPTION_ENABLED      : params.DB_ENCRYPTION_ENABLED,
            DB_IAM_ROLE                : params.DB_IAM_ROLE,
            DB_MAINTENANCE_WINDOW_DAY  : params.DB_MAINTENANCE_WINDOW_DAY,
            DB_MAINTENANCE_WINDOW_HOUR : params.DB_MAINTENANCE_WINDOW_HOUR,
            DB_MONITORING_ENABLED      : params.DB_MONITORING_ENABLED,
            ENABLE_CACHE               : params.ENABLE_CACHE
          ]

          // --- Sección: Replica / Failover
          def replica = [
            DB_FAILOVER_REPLICA_ENABLED: params.DB_FAILOVER_REPLICA_ENABLED,
            DB_READ_REPLICA_ENABLED    : params.DB_READ_REPLICA_ENABLED
          ]

          // Helper CPS-safe para imprimir ordenado
          def printSection = { String titulo, Map m ->
            echo "================= ${titulo} ================="
            def keys = m.keySet().toList(); keys.sort()
            for (k in keys) {
              def v = m[k]
              echo "${k}: ${v == null ? '' : v}"
            }
          }

          printSection('DEFAULT (Ocultas)', ocultas)
          printSection('GCP', gcp)
          printSection('TYPE / INSTANCIA', typeInst)
          printSection('REDES', redes)
          printSection('SEGURIDAD / OPERACIÓN', segOp)
          printSection('REPLICA / FAILOVER', replica)
        }
      }
    }
  }

  post {
    success { echo 'Pipeline ejecutado correctamente.' }
    failure { echo 'Error al ejecutar el pipeline.' }
  }
}
