# Recurso nulo para orquestrar a instalação e configuração no servidor local
resource "null_resource" "install_infrastack_on_local_server" {
  # Adiciona um "trigger" para que o Terraform re-execute este recurso
  # se o IP do servidor ou o caminho da chave SSH mudar.
  triggers = {
    ip_address = var.local_server_ip
    ssh_key    = var.local_server_ssh_key_path
  }

  # Configuração de conexão SSH com o servidor alvo
  connection {
    type        = "ssh"
    user        = var.local_server_user
    private_key = file(var.local_server_ssh_key_path) # Lê o conteúdo da chave privada
    host        = var.local_server_ip
    timeout     = "5m" # Tempo limite para a conexão SSH
  }

  # Provisionador para copiar o script de instalação do Docker para o servidor remoto
  provisioner "file" {
    source      = "${path.module}/scripts/install_docker.sh"
    destination = "/tmp/install_docker.sh" # Destino no servidor remoto
  }

  # Provisionador para copiar o arquivo docker-compose.yml para o servidor remoto
  provisioner "file" {
    source      = "${path.module}/scripts/docker-compose.yml"
    destination = "/tmp/docker-compose.yml" # Destino no servidor remoto
  }

  # Provisionador para executar comandos remotamente via SSH
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_docker.sh",    # Dá permissão de execução ao script
      "sudo /tmp/install_docker.sh",        # Executa o script de instalação do Docker
      "cd /tmp && sudo docker-compose up -d" # Navega para /tmp e sobe os containers com Docker Compose
    ]
  }

  # Bloco para garantir que a conexão SSH inicial possa ser estabelecida
  # Útil para servidores que acabaram de ser iniciados ou reiniciados.
  provisioner "remote-exec" {
    inline = ["echo 'Verificando conexão SSH e aguardando servidor...'"]
    connection {
      type        = "ssh"
      user        = var.local_server_user
      private_key = file(var.local_server_ssh_key_path)
      host        = var.local_server_ip
      timeout     = "10m" # Tempo limite maior para a primeira conexão
    }
  }
}
