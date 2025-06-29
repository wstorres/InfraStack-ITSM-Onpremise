# 📚 Manual de Implantação do InfraStack Local

---

Este manual foi criado para guiar você, passo a passo, na implantação do **InfraStack Local**, transformando seu servidor em um **host Docker completo** com todas as ferramentas essenciais. Não se preocupe se você não tem experiência prévia com Terraform ou Docker; vamos simplificar ao máximo!

---

## 🎯 O Que Você Vai Fazer

Você vai usar o **Terraform** para se conectar a um servidor Linux que você já possui. O Terraform automatizará a instalação do **Docker**, do **Docker Compose** e, em seguida, implantará **TODOS os serviços containerizados** (Portainer, GLPI, Zabbix, Grafana) usando um único arquivo `docker-compose.yml`. Após esta implantação inicial, o **Portainer** será sua interface principal para gerenciar os containers.

---

## 📝 Pré-requisitos (O Que Você Precisa Ter Antes de Começar)

Antes de iniciar, certifique-se de ter o seguinte:

1.  **Servidor Linux Disponível para ser Host Docker:**
    * Você precisa de um servidor físico ou uma máquina virtual (VM) **já instalada** e rodando **Ubuntu Server (versão 20.04 LTS ou mais recente)** ou **Debian**.
    * O servidor deve ter acesso à internet para baixar os pacotes necessários do Docker e as imagens dos containers.
    * Recomendamos pelo menos **4GB de RAM** e **2 vCPUs** para um bom desempenho de todas as aplicações containerizadas.
2.  **Acesso SSH ao Servidor Host:**
    * Você precisa de um usuário no servidor Linux que tenha permissão para usar `sudo` (geralmente o usuário inicial como `ubuntu` já tem).
    * Você precisa de uma **chave SSH (par de chaves pública e privada)** configurada para acessar este servidor remotamente a partir da sua máquina local (onde você executará o Terraform).
        * Se você não tem uma chave SSH, pode gerá-la na sua máquina local com `ssh-keygen` e copiar a chave pública para o servidor com `ssh-copy-id seu_usuario@ip_do_servidor`.
3.  **Git Instalado na sua Máquina Local:** O Git é uma ferramenta para baixar e gerenciar o código do projeto.
    * **Windows:** Baixe e instale o Git Bash em [git-scm.com/download/win](https://git-scm.com/download/win).
    * **macOS:** Você pode instalar via Homebrew (`brew install git`) ou instalar as Xcode Command Line Tools (`xcode-select --install`).
    * **Linux (Ubuntu/Debian):** `sudo apt update && sudo apt install git -y`.
4.  **Terraform Instalado na sua Máquina Local:** O Terraform é a ferramenta que fará a mágica de configurar seu servidor host Docker.
    * **Como instalar:** Siga as instruções oficiais no site da HashiCorp: [developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads). Escolha a versão para o seu sistema operacional.
    * Após a instalação, abra seu terminal (ou Git Bash no Windows) e digite `terraform version` para verificar se está funcionando.

---

## ⚙️ Configuração dos Arquivos do Projeto

Agora que você tem os pré-requisitos, vamos configurar os arquivos do projeto InfraStack Local na sua máquina local.

1.  **Clone o Repositório:** Abra seu terminal (ou Git Bash) e navegue até a pasta onde você quer baixar o projeto. Em seguida, clone o repositório do GitHub:

    ```bash
    git clone [https://github.com/SeuUsuario/infrastack-local.git](https://github.com/SeuUsuario/infrastack-local.git)
    cd infrastack-local
    ```

    *Substitua `SeuUsuario` pelo seu nome de usuário no GitHub.*

2.  **Edite o `terraform.tfvars`:**
    * Na pasta principal do projeto (`infrastack-local`), você encontrará um arquivo chamado `terraform.tfvars.example`.
    * **Faça uma cópia** deste arquivo e renomeie a cópia para **`terraform.tfvars`**. (É importante que seja exatamente esse nome, sem o `.example`).
    * Abra o arquivo `terraform.tfvars` (o novo, sem o `.example`) com um editor de texto (Ex: Bloco de Notas, VS Code, Sublime Text).
    * Preencha os valores das variáveis com as informações de conexão do seu servidor Linux (o host Docker):

        ```terraform
        local_server_ip           = "SEU_IP_DO_SERVIDOR" # Ex: "192.168.1.100" (IP do servidor Linux)
        local_server_user         = "SEU_USUARIO_SSH"    # Ex: "ubuntu" ou "admin" (Usuário SSH no servidor)
        local_server_ssh_key_path = "CAMINHO_PARA_SUA_CHAVE_PRIVADA_SSH" # Ex: "/home/seu_usuario/.ssh/id_rsa" ou "C:\\Users\\SeuUsuario\\.ssh\\id_rsa" (Caminho completo da sua chave privada)
        ```

    * **Salve as alterações** no arquivo `terraform.tfvars`.

3.  **Ajuste de Senhas no `scripts/docker-compose.yml`:**
    * Abra o arquivo `scripts/docker-compose.yml` com um editor de texto.
    * **MUDE AS SENHAS PADRÃO** para os serviços (GLPI, Zabbix e seus bancos de dados) por senhas fortes e seguras. Procure pelas linhas com `SUA_SENHA_FORTE` e substitua-as.
    * **Salve as alterações** no arquivo `scripts/docker-compose.yml`.

---

## 🚀 Hora da Implantação!

Com tudo configurado, você está pronto para mandar o Terraform configurar seu servidor host Docker.

1.  **Inicialize o Terraform:** No seu terminal, certifique-se de estar na pasta principal do projeto (`infrastack-local`). Execute o comando:

    ```bash
    terraform init
    ```

    Este comando baixa os plugins necessários para o Terraform. Você verá mensagens como "Terraform has been successfully initialized!".

2.  **Planeje a Implantação:** Antes de aplicar qualquer mudança, o Terraform pode mostrar o que ele vai fazer.

    ```bash
    terraform plan
    ```

    Ele listará as ações que serão realizadas no seu servidor (cópia de arquivos, execução de comandos SSH para instalar Docker e subir os containers). Verifique se faz sentido para você.

3.  **Aplique as Mudanças:** Se o plano parecer correto, é hora de configurar o host Docker e implantar as aplicações.

    ```bash
    terraform apply
    ```

    O Terraform perguntará se você quer realmente aplicar as mudanças. Digite `yes` e pressione Enter.
    Aguarde. Este processo pode levar alguns minutos, pois o Terraform estará se conectando ao servidor, instalando Docker/Docker Compose e subindo todos os containers.

---

## ✅ Verifique a Implantação e Acesse as Ferramentas

Quando o `terraform apply` terminar, ele exibirá as "Saídas" (Outputs). É aqui que você encontra as informações para acessar suas ferramentas:

### Outputs:

* glpi_url = "http://SEU_IP_DO_SERVIDOR/glpi"
* grafana_url = "http://SEU_IP_DO_SERVIDOR:3000"
* portainer_url = "http://SEU_IP_DO_SERVIDOR:9000"
* zabbix_url = "http://SEU_IP_DO_SERVIDOR:8080"

* **`portainer_url`:** Copie este URL e cole-o no seu navegador. Esta será a **primeira ferramenta a ser acessada**, pois é por onde você gerenciará seu ambiente Docker.
    * **Primeiro acesso ao Portainer:** Você será solicitado a criar um usuário e senha de administrador para o Portainer.
* **Outras URLs (`glpi_url`, `zabbix_url`, `grafana_url`):** Após configurar o Portainer, você pode acessar as interfaces web das outras ferramentas diretamente pelos URLs fornecidos.

    * **Importante:** Certifique-se de que o **firewall** do seu servidor local (ex: `ufw` no Ubuntu, ou regras de `iptables`) esteja configurado para permitir o acesso às portas **80 (GLPI), 8080 (Zabbix), 3000 (Grafana) e 9000 (Portainer)** a partir da sua rede.
    * **Primeiro acesso ao GLPI:** Siga o assistente de instalação. Use os dados do banco de dados que você configurou no `docker-compose.yml` (e alterou as senhas).
    * **Primeiro acesso ao Zabbix:** O login padrão geralmente é `Admin` com senha `zabbix`.
    * **Primeiro acesso ao Grafana:** O login padrão geralmente é `admin` com senha `admin`. Será pedido para você mudar a senha no primeiro login.

---

## 🗑️ Como Desfazer a Implantação (Limpeza)

O comando `terraform destroy` para este cenário local é um pouco diferente. Ele não desliga seu servidor físico ou VM. Em vez disso, ele pode ser usado para tentar parar os serviços Docker controlados pelo `docker-compose.yml` e remover os arquivos que o Terraform copiou para o servidor.

Para uma limpeza completa dos serviços InfraStack no seu servidor:

1.  **Conecte-se via SSH ao seu servidor host Docker:**

    ```bash
    ssh -i CAMINHO_PARA_SUA_CHAVE_PRIVADA_SSH SEU_USUARIO_SSH@SEU_IP_DO_SERVIDOR
    ```

    *Use o `ssh_access_tip` dos outputs do Terraform.*

2.  **No servidor, navegue até a pasta onde os arquivos foram copiados (`/tmp` por padrão) e pare/remova os containers e volumes:**

    ```bash
    cd /tmp # Ou onde você configurou o destino no main.tf
    sudo docker-compose down --volumes # Para e remove os containers, redes e volumes criados pelo docker-compose
    # Opcional: Se desejar remover TODAS as imagens Docker não utilizadas (CUIDADO!)
    # sudo docker system prune -a --volumes
    ```

3.  **Remova os arquivos de configuração copiados pelo Terraform:**

    ```bash
    sudo rm /tmp/install_docker.sh /tmp/docker-compose.yml
    ```

Lembre-se que o Terraform não desinstalará o Docker ou Docker Compose do seu servidor host. Isso precisaria ser feito manualmente se você não quiser mais ter o Docker instalado na máquina.

---
