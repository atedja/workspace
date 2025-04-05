FROM ubuntu:24.04
LABEL org.opencontainers.image.authors="albert@siliconaxon.com"

# Install core utils and libs.
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ=Etc/UTC
RUN apt update
RUN apt upgrade -y
RUN apt install -y tzdata
RUN apt install -y \
  apt-transport-https \
  build-essential \
  ca-certificates \
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

# Install GCC
RUN apt install -y manpages-dev g++ valgrind

# Install Python and pip
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update
RUN apt install -y python3-dev python3-venv python3-pip

# Set up temporary folders for installation
ENV SETUP_DIR=setup
RUN mkdir -p /${SETUP_DIR}
WORKDIR /${SETUP_DIR}

# Install go
ENV GO_VERSION=1.24.2
RUN curl https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o golang.tar.gz
RUN tar -C /usr/local -xzf golang.tar.gz
ENV PATH=${PATH}:/usr/local/go/bin

# Install redis-cli
RUN add-apt-repository ppa:redislabs/redis
RUN apt install -y redis-tools

# Install postgres-client
RUN apt install -y postgresql-client

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Copy custom binaries and configurations
ADD usr /usr

# Set up the home folder
ENV HOME=/root

# Vim and plugins
RUN mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
RUN curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
RUN git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
RUN git clone https://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized
RUN git clone https://github.com/leafgarland/typescript-vim.git ~/.vim/bundle/typescript-vim
RUN git clone https://github.com/godlygeek/tabular.git ~/.vim/bundle/tabular

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION=1.29.2
RUN curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install AWS Vault
ENV AWS_VAULT_VERSION=v6.5.0
RUN curl -fsSL "https://github.com/99designs/aws-vault/releases/download/${AWS_VAULT_VERSION}/aws-vault-linux-amd64" -o /usr/local/bin/aws-vault
RUN chmod +x /usr/local/bin/aws-vault

# Set up locales
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# Cleanup Installation
RUN apt autoclean && apt autoremove
RUN rm -rf /${SETUP_DIR}

# Copy dotfiles and assign home as workdir
ADD home $HOME
ADD .ssh $HOME/.ssh
WORKDIR $HOME
