FROM ruby:3.3.10-slim AS rails-app

ENV BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    RAILS_ENV=development \
    NODE_ENV=production

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      curl \
      git \
      libmariadb-dev \
      libyaml-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists/*

COPY api/Gemfile api/Gemfile.lock ./
RUN bundle install
COPY api/ .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

# -------- Vue build stage --------
FROM node:lts-alpine AS ui-build
WORKDIR /app
COPY ui/package*.json ./
RUN npm install
COPY ui/ .
ARG VUE_APP_API_BASE_URL=http://localhost:3000
ENV VUE_APP_API_BASE_URL=${VUE_APP_API_BASE_URL}
RUN npm run build

# -------- Vue runtime stage --------
FROM nginx:stable-alpine AS ui-app
COPY --from=ui-build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
