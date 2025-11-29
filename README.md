# Ruby Demo (Rails 7 API + MySQL)

Repositório reiniciado para uma nova fase: uma API Rails moderna rodando sobre Ruby **3.3.10**, exposta via Puma e com MySQL containerizado. A raiz está organizada em dois módulos:

- `api/` – aplicação Rails 7.2.3 (modo API) utilizando `mysql2`.
- `ui/` – front-end Vue 2 + [BootstrapVue](https://bootstrap-vue.org/) pronto para consumir a API.

## Stack

- Ruby 3.3.10 (RVM + gemset `ruby-demo`)
- Rails 7.2.3
- Puma
- MySQL 8.4 (dockerizado)
- Docker + Docker Compose usando `ruby:3.3.10-slim`

## Comandos iniciais utilizados

Esses foram os passos executados após o reset para preparar o ambiente Ruby e gerar a API:

```bash
# garantir que o RVM esteja carregado
source ~/.rvm/scripts/rvm

# criar/usar a gemset
rvm use 3.3.10@ruby-demo --create

# instalar ferramentas
gem install bundler
gem install rails -v 7.2.3

# gerar a aplicação
rails new api --api -d mysql \
  --skip-action-mailbox \
  --skip-action-text \
  --skip-test
```

## Executando com Docker

```bash
docker compose build          # monta a imagem ruby:3.3.10-slim + gems
docker compose run --rm api bin/rails db:prepare # cria o schema no MySQL
docker compose up             # sobe API (porta 3000), UI (porta 8080) + MySQL (porta 3306)
```

A documentação da API está disponível em `http://localhost:3000/` assim que o container `api` estiver de pé (é redida pelo RSwag direto na raiz). Já o front-end Vue fica publicado automaticamente em `http://localhost:8080/`, servido por um NGINX gerado a partir do build do BootstrapVue.

A aplicação Rails conversa com o banco usando as credenciais fixas:

- host `db`
- user `ruby-demo`
- password `2u8y-c0d3`
- databases `ruby_demo_development` / `ruby_demo_test`

Essas variáveis já vêm definidas no `docker-compose.yml`, mas podem ser sobrescritas ao rodar localmente.

## Desenvolvimento fora do Docker

1. Configure o RVM: `rvm use 3.3.10@ruby-demo --create`.
2. Instale dependências dentro de `api/`: `bundle install`.
3. Exporte as variáveis de banco (ou use um `.env`) e rode `bin/rails db:prepare`.
4. Inicie o servidor: `bin/rails server -b 0.0.0.0`.
5. Abra `http://localhost:3000/` para visualizar o Swagger alimentado pelo RSwag.

## UI (Vue + BootstrapVue)

O diretório `ui/` foi criado com Vue CLI (Vue 2) e já vem com o BootstrapVue configurado.

```bash
cd ui
npm install      # primeira execução
npm run serve    # disponível em http://localhost:8080
```

Para usar os componentes, veja a documentação oficial em https://bootstrap-vue.org/. O `App.vue` contém um layout inicial com exemplos usando `<b-container>`, `<b-card>` e `<b-button>` para servir como guia. Para empacotar a UI em contêiner seguimos a receita oficial da Vue CLI para dockerização (com build multi-stage Node + NGINX) [documentada aqui](https://v2.vuejs.org/v2/cookbook/dockerize-vuejs-app.html?redirect=true).