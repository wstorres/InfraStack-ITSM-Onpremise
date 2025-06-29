# Saídas importantes após a implantação
output "glpi_url" {
  description = "URL provável do GLPI."
  value       = "http://${var.local_server_ip}/glpi"
}

output "zabbix_url" {
  description = "URL provável do Zabbix."
  value       = "http://${var.local_server_ip}:8080"
}

output "grafana_url" {
  description = "URL provável do Grafana."
  value       = "http://${var.local_server_ip}:3000"
}

output "portainer_url" {
  description = "URL provável do Portainer."
  value       = "http://${var.local_server_ip}:9000"
}

output "ssh_access_tip" {
  description = "Dica de como acessar o servidor via SSH."
  value       = "ssh -i ${var.local_server_ssh_key_path} ${var.local_server_user}@${var.local_server_ip}"
}
