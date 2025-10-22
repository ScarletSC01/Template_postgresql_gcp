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
    // CONTROL DE ACCIÓN
    choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Acción de Terraform a ejecutar.')

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

  // Helper para generar todos los -var=...
  def getTerraformVars() {
    def vars = [
      "PROJECT_ID": params.PROJECT_ID,
      "REGION": params.REGION,
      "ZONE": params.ZONE,
      "ENVIRONMENT": params.ENVIRONMENT,
      "DB_INSTANCE_NAME": params.DB_INSTANCE_NAME,
      "DB_AVAILABILITY_TYPE": params.DB_AVAILABILITY_TYPE,
      "DB_VERSION": params.DB_VERSION,
      "MACHINE_TYPE": params.MACHINE_TYPE,
      "DB_MAX_CONNECTIONS": params.DB_MAX_CONNECTIONS,
      "DB_STORAGE_SIZE": params.DB_STORAGE_SIZE,
      "DB_STORAGE_AUTO_RESIZE": params.DB_STORAGE_AUTO_RESIZE,
      "DB_STORAGE_TYPE": params.DB_STORAGE_TYPE,
      "DB_USERNAME": params.DB_USERNAME,
      "DB_PASSWORD": params.DB_PASSWORD,
      "DB_VPC_NETWORK": params.DB_VPC_NETWORK,
      "DB_PRIVATE_IP_ENABLED": params.DB_PRIVATE_IP_ENABLED,
      "DB_PUBLIC_ACCESS_ENABLED": params.DB_PUBLIC_ACCESS_ENABLED,
      "DB_IP_RANGE_ALLOWED": params.DB_IP_RANGE_ALLOWED,
      "DB_BACKUP_START_TIME": params.DB_BACKUP_START_TIME,
      "DB_BACKUP_RETENTION_DAYS": params.DB_BACKUP_RETENTION_DAYS,
      "DB_MAINTENANCE_WINDOW_DAY": params.DB_MAINTENANCE_WINDOW_DAY,
      "DB_MAINTENANCE_WINDOW_HOUR": params.DB_MAINTENANCE_WINDOW_HOUR,
      "DB_MONITORING_ENABLED": params.DB_MONITORING_ENABLED,
      "DB_AUDIT_LOGS_ENABLED": params.DB_AUDIT_LOGS_ENABLED,
      "DB_DELETION_PROTECTION": params.DB_DELETION_PROTECTION,
      "DB_ENCRYPTION_ENABLED": params.DB_ENCRYPTION_ENABLED,
      "ENABLE_CACHE": params.ENABLE_CACHE,
      "CHECK_DELETE": params.CHECK_DELETE,
      "CREDENTIAL_FILE": params.CREDENTIAL_FILE,
      "DB_IAM_ROLE": params.DB_IAM_ROLE,
      "DB_FAILOVER_REPLICA_ENABLED": params.DB_FAILOVER_REPLICA_ENABLED,
      "DB_READ_REPLICA_ENABLED": params.DB_READ_REPLICA_ENABLED
    ]

    def varString = vars.collect { k, v -> "-var=\"${k}=${v}\"" }.join(' ')
    return varString
  }

  stages {
    
    stage('Terraform Plan') {
      when { expression { params.ACTION == 'plan' || params.ACTION == 'apply' } }
      steps {
        script {
          withCredentials([file(credentialsId: 'gcp-sa-platform', variable: 'GCP_CREDENTIALS')]) {
            sh "export GOOGLE_APPLICATION_CREDENTIALS='${GCP_CREDENTIALS}'"

            dir('terraform') { 
              echo "Inicializando Terraform..."
              sh 'terraform init'

              echo "Creando plan de ejecución con las variables de Jenkins..."
              def tfVars = getTerraformVars()
              
              // Ejecutar Terraform Plan y guardarlo en un archivo para la etapa 'apply'
              sh "terraform plan ${tfVars} -out=tfplan"
              
              // Archivar el plan para usarlo en la siguiente etapa
              archiveArtifacts artifacts: 'tfplan', fingerprint: true
            }
          }
        }
      }
    }
    
    ---
    
    stage('Terraform Apply') {
      when { expression { params.ACTION == 'apply' } }
      steps {
        script {
          withCredentials([file(credentialsId: 'gcp-sa-platform', variable: 'GCP_CREDENTIALS')]) {
            sh "export GOOGLE_APPLICATION_CREDENTIALS='${GCP_CREDENTIALS}'"

            dir('terraform') { 
              echo "Descargando el plan guardado..."
              // Descargar el tfplan generado en la etapa anterior
              // Nota: Esto requiere que el pipeline se ejecute en el mismo workspace o use un almacenamiento de estado remoto.
              // Asumimos que el artifact está disponible.
              
              // Descargar artefacto si se ejecuta en un nuevo executor
              // steps { copyArtifacts(projectName: env.JOB_NAME, selector: lastSuccessful(), artifacts: 'terraform/tfplan') } 
              
              // Si se ejecuta en el mismo executor:
              sh 'if [ -f tfplan ]; then echo "Usando tfplan local."; else echo "Error: tfplan no encontrado. Asegúrese de ejecutar 'plan' primero."; exit 1; fi'

              echo "Aplicando cambios de infraestructura desde el plan..."
              sh 'terraform apply -auto-approve tfplan' 
              
              echo "Guardando salidas de Terraform."
              sh 'terraform output -json > output.json'
            }
          }
        }
      }
    }
    
    ---
    
    stage('Terraform Destroy') {
      when { expression { params.ACTION == 'destroy' } }
      steps {
        script {
          // Se añade una verificación para evitar borrados accidentales
          if (params.ENVIRONMENT == '3-Produccion' && params.CHECK_DELETE != 'true') {
            error("Operación DESTROY en PRODUCCIÓN no permitida. Ajuste el parámetro CHECK_DELETE a 'true' para confirmar.")
          }
          
          withCredentials([file(credentialsId: 'gcp-sa-platform', variable: 'GCP_CREDENTIALS')]) {
            sh "export GOOGLE_APPLICATION_CREDENTIALS='${GCP_CREDENTIALS}'"

            dir('terraform') { 
              echo "Inicializando Terraform para destruir la infraestructura..."
              sh 'terraform init'
              
              echo "Ejecutando DESTROY. Esto eliminará todos los recursos gestionados por este estado de Terraform."
              // El comando destroy debe usar -auto-approve para ser no interactivo
              def tfVars = getTerraformVars()
              sh "terraform destroy ${tfVars} -auto-approve" 
            }
          }
        }
      }
    }
  }

  post {
    success { echo 'Pipeline ejecutado correctamente.' }
    failure { echo 'Error al ejecutar el pipeline.' }
  }
}
