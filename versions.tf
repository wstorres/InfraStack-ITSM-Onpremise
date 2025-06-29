# Define as versões mínimas necessárias para o Terraform e provedores
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    # Usamos o provedor 'null' para gerenciar a execução de comandos remotos
    # e o provedor 'local' para interagir com arquivos locais.
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
