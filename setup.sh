#!/usr/bin/env bash

# Nome do serviço conforme definido no docker-compose.yml
SERVICE_NAME="rails-dev"

# UID/GID do usuário do host
export UID=$(id -u)
export GID=$(id -g)

# Verifica se já existe um container rodando com esse nome
CONTAINER_RUNNING=$(docker ps --filter "name=${SERVICE_NAME}" --filter "status=running" -q)

if [ -n "$CONTAINER_RUNNING" ]; then
  echo "✅ O container '${SERVICE_NAME}' já está rodando (ID: $CONTAINER_RUNNING)"
else
  echo "📦 Container '${SERVICE_NAME}' não está rodando. Construindo e iniciando..."

  # Builda com UID/GID do host
  docker compose build --build-arg UID=$UID --build-arg GID=$GID

  # Sobe o container em background
  docker compose up -d
fi
