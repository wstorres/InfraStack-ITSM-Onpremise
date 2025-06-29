#!/bin/bash
# Script para instalar Docker e Docker Compose em um sistema baseado em Debian/Ubuntu

echo "Iniciando a instalação do Docker e Docker Compose..."

# Atualiza a lista de pacotes
sudo apt-get update -y

# Instala pacotes necessários para o Docker
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Adiciona a chave GPG oficial do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona o repositório estável do Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza a lista de pacotes novamente com o novo repositório
sudo apt-get update -y

# Instala Docker Engine, CLI e Containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Instala Docker Compose v2 (versão mais recente e integrada com o Docker CLI)
# Verifica a última versão do Docker Compose na página de releases do GitHub
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K[^"]*')
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Cria link simbólico para docker-compose se não existir (para compatibilidade)
if [ ! -f /usr/bin/docker-compose ]; then
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

# Adiciona o usuário atual ao grupo docker para poder executar comandos docker sem sudo
sudo usermod -aG docker ${SUDO_USER:-$(whoami)}

echo "Docker e Docker Compose instalados com sucesso!"
echo "Por favor, faça logout e login novamente (ou reinicie a sessão SSH) para que as mudanças no grupo 'docker' tenham efeito."

# Nota: O Docker Compose será executado pelo Terraform logo após este script ser executado.
