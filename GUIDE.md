# 📚 Manual de Implantação do InfraStack Local

---

Este manual foi criado para guiar você, passo a passo, na implantação do **InfraStack Local** em seu próprio servidor físico ou máquina virtual local. Não se preocupe se você não tem experiência prévia com Terraform ou Docker; vamos simplificar ao máximo!

---

## 🎯 O Que Você Vai Fazer

Você vai usar o **Terraform** para se conectar a um servidor Linux que você já possui e automatizar a instalação do Docker, Docker Compose e a implantação das ferramentas GLPI, Zabbix, Grafana e Portainer via containers.

---

## 📝 Pré-requisitos (O Que Você Precisa Ter Antes de Começar)

Antes de iniciar, certifique-se de ter o seguinte:

1.  **Servidor Linux Disponível:**
    * Você precisa de um servidor físico ou uma máquina virtual (VM) rodando **Ubuntu Server (versão 20.04 LTS ou mais recente)** ou **Debian**.
    * O servidor deve ter acesso à internet para baixar os pacotes necessários.
    * Recomendamos pelo menos **4GB de RAM** e **2 vCPUs** para um bom desempenho de todas as aplicações.
2.  **Acesso SSH ao Servidor:**
    * Você precisa de um usuário no servidor Linux que tenha permissão para usar `sudo` (geralmente o usuário inicial como `ubuntu` já tem).
    * Você precisa de uma **chave SSH (par de chaves pública e privada)** configurada para acessar este servidor remotamente.
        * Se você não tem uma chave SSH, pode gerá-la na sua máquina local com `ssh-keygen` e copiar a chave pública para o servidor com `ssh-copy-id seu_usuario@ip_do_servidor`.
3.  **Git Instalado:** O Git é uma ferramenta para baixar e gerenciar o código do projeto.
    * **Windows:** Baixe e instale o Git Bash em [git-scm.com/download/win](https://git-scm.com/download/win).
    * **macOS:** Você pode instalar via Homebrew (`brew install git`) ou instalar as Xcode Command Line Tools (`xcode-select --install`).
    * **Linux (Ubuntu/Debian):** `sudo apt update && sudo apt install git -y`.
4.  **Terraform Instalado:** O Terraform é a ferramenta que fará a mágica de configurar sua infraestrutura.
    * **Como instalar:** Siga as instruções oficiais no site da HashiCorp: [developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads). Escolha a versão para o seu sistema operacional.
    * Após a instalação, abra seu terminal (ou Git Bash no Windows) e digite `terraform version` para verificar se está funcionando.

---

## ⚙️ Configuração dos Arquivos do Projeto

Agora que você tem os pré-requisitos, vamos configurar os arquivos do projeto InfraStack Local.

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
    * Preencha os valores das variáveis com as informações do seu servidor local:

        ```terraform
        local_server_ip           = "SEU_IP_DO_SERVIDOR" # Ex: "192.168.1.100"
        local_server_user         = "SEU_USUARIO_SSH"    # Ex: "ubuntu" ou "admin"
        local_server_ssh_key_path = "CAMINHO_PARA_SUA_CHAVE_PRIVADA_SSH" # Ex: "/home/seu_usuario/.ssh/id_rsa" ou "C:\\Users\\SeuUsuario\\.ssh\\id_rsa"
        ```

    * **Salve as alterações** no arquivo `terraform.tfvars`.

3.  **Ajuste de Senhas no `scripts/docker-compose.yml`:**
    * Abra o arquivo `scripts/docker-compose.yml` com um editor de texto.
    * **MUDE AS SENHAS PADRÃO** para os serviços GLPI e Zabbix por senhas fortes e seguras. Procure por `sua_senha_segura` ou similar e substitua.
    * **Salve as alterações** no arquivo `scripts/docker-compose.yml`.

---

## 🚀 Hora da Implantação!

Com tudo configurado, você está pronto para mandar o Terraform configurar seu servidor.

1.  **Inicialize o Terraform:** No seu terminal, certifique-se de estar na pasta principal do projeto (`infrastack-local`). Execute o comando:

    ```bash
    terraform init
    ```

    Este comando baixa os plugins necessários para o Terraform. Você verá mensagens como "Terraform has been successfully initialized!".

2.  **Planeje a Implantação:** Antes de aplicar qualquer mudança, o Terraform pode mostrar o que ele vai fazer.

    ```bash
    terraform plan
    ```

    Ele listará as ações que serão realizadas no seu servidor (cópia de arquivos, execução de comandos SSH). Verifique se faz sentido para você.

3.  **Aplique as Mudanças:** Se o plano parecer correto, é hora de configurar a infraestrutura.

    ```bash
    terraform apply
    ```

    O Terraform perguntará se você quer realmente aplicar as mudanças. Digite `yes` e pressione Enter.
    Aguarde. Este processo pode levar alguns minutos, pois o Terraform estará se conectando ao servidor, instalando Docker e subindo os containers.

---

## ✅ Verifique a Implantação

Quando o `terraform apply` terminar, ele exibirá as "Saídas" (Outputs). É aqui que você encontra as informações para acessar suas ferramentas:
