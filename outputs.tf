output "instance_master_connection_name" {
  description = "Nombre de conexión de la instancia maestra (e.g., project:region:name)"
  value       = google_sql_database_instance.master.connection_name
}

output "instance_master_private_ip" {
  description = "IP privada de la instancia maestra"
  value       = google_sql_database_instance.master.private_ip_address
}

output "instance_read_replica_connection_name" {
  description = "Nombre de conexión de la réplica de lectura (si existe)"
  value       = var.DB_READ_REPLICA_ENABLED == "true" ? google_sql_database_instance.read_replica[0].connection_name : "N/A"
}

output "db_app_username" {
  description = "Nombre de usuario de la aplicación creado"
  value       = google_sql_user.app_user.name
}
