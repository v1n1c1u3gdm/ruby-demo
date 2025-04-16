# 💎 Projeto Rails com Docker (Ruby 2.6 + Rails 5.2)

Este projeto roda em um ambiente Dockerizado, compatível com qualquer host com suporte a Docker mas foi testado com Fedora 41 e Docker-CE, Windows 11 c/ WSL2. O projeto é essencialmente o resultado do meu aprendizado conforme estudo realizado através do curso https://www.udemy.com/course/draft/1694986/#:~:text=Descri%C3%A7%C3%A3o,de%20desenvolvimento%20Web%20com%20Rails.

A stack inclui (conforme o curso):

- ubuntu:20.04 (por conveniência o mesmo do WSL2 em abr/25)
- Ruby 2.6.10 via RVM
- Rails 5.2
- Node.js 18 via NVM
- SQLite3
- Docker + Docker Compose

---

## 🚀 Guia rápido
Execute os seguintes comandos para executar a aplicação rapidamente

### Dentro do host (quem roda o docker)
O script *(setup.sh*) vai exportar seu UID e GID, "buildar" o container (caso necessário) e subir o ambiente em modo detached. Acesse o container com attach do docker e utilize o path /app para "conectar-se" ao seu sistema host. Todo controle de versão foi pensado para ocorrer a partir do host (utilize o parâmetro *services > rails-dev > build > volumes* para definitir onde isso dar-se-á dentro do guest)

```bash
git clone git@github.com:$SUA_CONTA_GITHUB/ruby-demo.git
cd ruby-demo
chmod +x setup.sh
./setup.sh
docker container ls # descubra qual o id de container foi gerado para você
docker attach 654s8476968 # utilize o id identificado na linha acima
```

### Dentro do guest (o container)
```bash
rails new .
bundle install
rails db:migrate
rails s -b 0.0.0.0 # vai permitir acesso à execução a partir do host.
```

Agora siga seu fluxo de desenvolvimento RoR normal.