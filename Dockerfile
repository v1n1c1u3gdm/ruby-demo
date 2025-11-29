FROM ruby:3.3.10-slim

ENV BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    RAILS_ENV=development \
    NODE_ENV=production

WORKDIR /app

# Install system dependencies for building gems such as mysql2
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      curl \
      git \
      libmariadb-dev \
      pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Install Ruby gems
COPY api/Gemfile api/Gemfile.lock ./
RUN bundle install

# Copy the rest of the Rails API
COPY api/ .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
