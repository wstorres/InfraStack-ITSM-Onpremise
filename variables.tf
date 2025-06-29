# Variáveis para configuração do servidor local
variable "local_server_ip" {
  description = "Endereço IP do servidor Linux local onde o InfraStack será implantado."
  type        = string
}

variable "local_server_user" {
  description = "Nome de usuário SSH para acesso ao servidor local (ex: ubuntu, ec2-user). Este usuário deve ter permissões sudo."
  type        = string
  default     = "ubuntu" # Altere se seu usuário SSH for diferente
}

variable "local_server_ssh_key_path" {
  description = "Caminho completo para o arquivo da chave privada SSH (.pem ou .id_rsa) para autenticação no servidor local."
  type        = string
}
