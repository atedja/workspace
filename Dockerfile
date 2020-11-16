FROM ubuntu:20.04
MAINTAINER albert@siliconaxon.com

# Install core utils and libs.
RUN apt update
RUN apt upgrade -y
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata
RUN apt install -y \
  apt-transport-https \
  build-essential \
  ca-certificates \
  curl \
  curl \
  dnsutils \
  git \
  gnupg2 \
  jq \
  locales \
  man \
  mc \
  netcat-openbsd \
  pv \
  software-properties-common \
  strace \
  sudo \
  tmux \
  tree \
  unzip \
  vim \
  wget \
  zip

ENV SETUP_DIR setup
RUN mkdir -p /${SETUP_DIR}
WORKDIR /${SETUP_DIR}

# Set up locales
RUN rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.UTF-8

# Install Python and pip
RUN add-apt-repository universe 
RUN apt update
RUN apt install -y python3-pip python3-venv

# Install redis-cli
RUN apt install -y redis-tools

# Install postgres-client
RUN apt install -y postgresql-client

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Install go
ENV GO_VERSION 1.15
RUN curl https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o golang.tar.gz
RUN tar -C /usr/local -xzf golang.tar.gz
ENV PATH=${PATH}:/usr/local/go/bin

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
RUN apt update
RUN apt-cache policy docker-ce
RUN apt install -y docker-ce

# Copy custom binaries and configurations
ADD usr /usr

# Set up the home folder
ENV HOME /root
ADD home $HOME
ADD .ssh $HOME/.ssh

# Vim and plugins
RUN mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
RUN curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
RUN git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
RUN git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized

# PHP
ENV DEBIAN_FRONTEND=noninteractive
ENV PHP_VERSION 7.4
ENV PHP_COMPOSER_VERSION 2.0.7
RUN add-apt-repository ppa:ondrej/php
RUN apt update
RUN apt install -y php${PHP_VERSION}
RUN curl -sSL https://getcomposer.org/download/${PHP_COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer.phar
RUN chmod +x /usr/local/bin/composer.phar

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION 1.27.4
RUN curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install AWS Vault
ENV AWS_VAULT_VERSION v6.2.0
RUN curl -fsSL "https://github.com/99designs/aws-vault/releases/download/${AWS_VAULT_VERSION}/aws-vault-linux-amd64" -o /usr/local/bin/aws-vault
RUN chmod +x /usr/local/bin/aws-vault

# Cleanup Installation
RUN apt autoclean && apt autoremove
RUN rm -rf /${SETUP_DIR}

WORKDIR $HOME
