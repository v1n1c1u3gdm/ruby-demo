# Ruby Demo (Rails 7 API + MySQL)

Repositório reiniciado para uma nova fase: uma API Rails moderna rodando sobre Ruby **3.3.10**, exposta via Puma e com MySQL containerizado. A raiz está organizada em dois módulos:

- `api/` – aplicação Rails 7.2.3 (modo API) utilizando `mysql2`.
- `ui/` – front-end Vue 2 + [BootstrapVue](https://bootstrap-vue.org/) pronto para consumir a API.

## Arquitetura & Tecnologias

- **API (`api/`)**: Rails 7.2.3 em Ruby 3.3.10, servida pelo Puma. O projeto está no modo API, usa Active Record com o adapter `mysql2`, expõe a documentação Swagger via RSwag e conversa com o banco através de variáveis fornecidas pelo Docker Compose.
- **UI (`ui/`)**: Vue 2 criado com Vue CLI e estilizado com BootstrapVue. Em desenvolvimento roda com `npm run serve`; em produção o bundle é entregue por um NGINX gerado em build multi-stage.
- **Banco (`db`)**: MySQL 8.4 rodando em container dedicado com volume persistente e credenciais fixas (`ruby-demo` / `2u8y-c0d3`).
- **Orquestração**: Docker Compose define os serviços `api`, `ui` e `db`, compartilhando a mesma rede bridge para que o Rails consuma o host `db`. O arquivo `docker-compose.yml` também injeta as variáveis de ambiente necessárias para Active Record e para o build do front-end.
- **Observabilidade**: Instrumentação automática configurada com OpenTelemetry (`opentelemetry-sdk`, `opentelemetry-metrics-sdk` e `opentelemetry-instrumentation-all`). A API publica dois endpoints utilitários – `GET /liveness` para sondagens básicas e `GET /metrics` em formato Prometheus/OpenMetrics para scraping externo.

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

## Como iniciar com Docker

### Pré-requisitos

- Docker 24+ instalado (ou Desktop recente).
- Plugin Docker Compose v2.
- Portas 3000 (API), 3306 (MySQL) e 8080 (UI) livres.

### Passo a passo rápido

```bash
docker compose build
docker compose run --rm api bin/rails db:prepare
docker compose up
```

- `docker compose build` monta a imagem baseada em `ruby:3.3.10-slim`, instala gems e produz o bundle da UI.
- `docker compose run --rm api bin/rails db:prepare` garante que o schema exista no MySQL do serviço `db`.
- `docker compose up` sobe todo o stack. Use `-d` se quiser rodar em background e `docker compose logs -f api` para acompanhar o Rails.

Assim que o container `api` estiver de pé, a documentação Swagger alimentada pelo RSwag fica disponível em `http://localhost:3000/`. O front-end Vue sobe automaticamente em `http://localhost:8080/`, servido por NGINX.

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