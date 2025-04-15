FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV RVM_PATH="/usr/local/rvm"
ENV NVM_DIR="/usr/local/nvm"

RUN apt-get update && apt-get install -y \
  curl gnupg2 autoconf bison build-essential libssl-dev \
  libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev \
  libffi-dev libgdbm-dev git libsqlite3-dev shared-mime-info mc

# GPG para RVM
RUN gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys \
  409B6B1796C275462A1703113804BB82D39DC0E3 \
  7D2BAF1CF37B13E2069D6956105BD0E739499BDB

SHELL ["/bin/bash", "-lc"]
COPY Gemfile Gemfile

# Instalações básicas
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN source /etc/profile.d/rvm.sh
RUN rvm install 2.6.10
RUN rvm use 2.6.10 --default
RUN gem update --system 3.3.22
# RUN gem install bundler -v 1.17.3
# RUN bundle _1.17.3_ lock --add-platform x86_64-linux
RUN gem install bundler -v 2.2.33
RUN bundle _2.2.33_ lock --add-platform x86_64-linux
RUN bundle _2.2.33_ install

RUN echo 'source /etc/profile.d/rvm.sh' >> /root/.bashrc

RUN mkdir -p $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN bash -lc "export NVM_DIR='/usr/local/nvm' && \
  . \"$NVM_DIR/nvm.sh\" && \
  nvm install 18 && \
  nvm alias default 18"
  
# Garante que o NVM esteja disponível em shells interativos
RUN echo 'export NVM_DIR="/usr/local/nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc
    
RUN echo "alias rails s='rails s -b 0.0.0.0'" >> /root/.bashrc

ARG UID=1000
ARG GID=1000

RUN group_name=$(getent group $GID | cut -d: -f1 || echo "devgroup") && \
    getent group $GID || groupadd -g $GID "$group_name" && \
    useradd -m -u $UID -g $GID devuser && \
    echo 'source /etc/profile.d/rvm.sh' >> /home/devuser/.bashrc && \
    echo 'export NVM_DIR="/usr/local/nvm"' >> /home/devuser/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/devuser/.bashrc && \
    chown devuser:$GID /home/devuser/.bashrc

USER devuser
WORKDIR /app
