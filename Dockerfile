FROM ubuntu:18.04
MAINTAINER albert@siliconaxon.com

# Install core utils and libs.
RUN apt update
RUN apt install -y \
  build-essential \
  curl \
  dnsutils \
  git \
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
  wget \
  zip

ENV SETUP_DIR setup
RUN mkdir -p /${SETUP_DIR}
WORKDIR /${SETUP_DIR}

# Install Python and pip
RUN apt install -y python python3 python3-pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN pip3 install virtualenv

# Install vim
RUN apt install -y vim

# Install redis-cli
RUN apt install -y redis-tools

# Install postgres-client
RUN apt install -y postgresql-client

# Install Terraform
ENV TERRAFORM_VERSION 0.11.8
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip
RUN unzip terraform.zip -d /usr/bin/ && rm terraform.zip

# Install Ansible
ENV ANSIBLE_VERSION 2.6.2
RUN pip install ansible==${ANSIBLE_VERSION}

# Install AWS CLI
ENV AWS_CLI_VERSION 1.15.62
RUN pip install awscli==${AWS_CLI_VERSION}

# Install go
ENV GO_VERSION 1.10.3
RUN curl https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -o golang.tar.gz
RUN tar -C /usr/local -xzf golang.tar.gz
ENV PATH=${PATH}:/usr/local/go/bin

# Install OpenVPN
RUN apt install -y openvpn

# Copy custom binaries and configurations
ADD usr /usr

# Set up the home folder
ENV HOME /root
ADD home $HOME
ADD .ssh $HOME/.ssh

# Install RVM (this must be after setting up the home folder because RVM changes .bashrc)
RUN echo 'export rvm_prefix="$HOME"' > $HOME/.rvmrc
RUN echo 'export rvm_path="$HOME/.rvm"' >> $HOME/.rvmrc
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby

# Vim and plugins
RUN mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
RUN curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
RUN git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go
RUN git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized

# PHP
ENV DEBIAN_FRONTEND=noninteractive
ENV PHP_VERSION 7.2
ENV PHP_COMPOSER_VERSION 1.7.2
RUN apt install -y php${PHP_VERSION}
RUN \curl -sSL https://getcomposer.org/download/${PHP_COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer.phar
RUN chmod +x /usr/local/bin/composer.phar

# Install Docker
RUN apt install -y apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
RUN apt update
RUN apt install -y docker-ce

# Install AWS Vault
ENV AWS_VAULT_VERSION v4.4.1
RUN curl -fsSL "https://github.com/99designs/aws-vault/releases/download/${AWS_VAULT_VERSION}/aws-vault-linux-amd64" -o /usr/local/bin/aws-vault
RUN chmod +x /usr/local/bin/aws-vault

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION 1.22.0
RUN curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Additional libraries
RUN apt install -y jq

# Cleanup Installation
RUN apt autoclean && apt autoremove
RUN rm -rf /${SETUP_DIR}

WORKDIR $HOME
