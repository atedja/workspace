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
RUN apt install -y python python3
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

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

# Cleanup Installation
RUN apt autoclean && apt autoremove
RUN rm -rf /${SETUP_DIR}

# Copy custom binaries and configurations
ADD usr /usr

# Set up the home folder
ENV HOME /root
ADD home $HOME
ADD .ssh $HOME/.ssh
RUN mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
RUN curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
WORKDIR $HOME

# Install RVM (this is after setting up the home folder because RVM changes .bashrc)
RUN echo 'export rvm_prefix="$HOME"' > $HOME/.rvmrc
RUN echo 'export rvm_path="$HOME/.rvm"' >> $HOME/.rvmrc
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN \curl -sSL https://get.rvm.io | bash -s stable --ruby
