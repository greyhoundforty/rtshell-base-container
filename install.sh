#!/bin/bash
set -e

echo ">> Updating system"
apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update

echo ">> Installing dependencies..."
PACKAGES=(
  apache2-utils \
  apt-transport-https \
  bash-completion \
  ca-certificates \
  curl \
  gnupg \
  inetutils-ping \
  jq \
  locales \
  lsb-release \
  nano \
  python3-argcomplete \
  python3-pip \
  python3-setuptools \
  python3-virtualenv \
  silversearcher-ag \
  software-properties-common \
  unzip \
  vim \
  wget \
  zip \
)

for package in "${PACKAGES[@]}"; do
  echo "Processing $package..."
  apt-get install -qq -y $package || true
done

# Locale
echo ">> Genrating Locales"
locale-gen en_US.UTF-8

# Docker in Docker
echo ">> Enabling Docker in Docker"
apt remove docker docker-engine docker.io containerd runc || true
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -qq update
apt-get -qq -y install docker-ce docker-ce-cli containerd.io


echo ">> TFSwitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# Ansible
echo ">> Ansible"
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -qq -y ansible

# Packer
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository --yes --update "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt install -qq -y packer

# Latest Git
echo ">> Git"
add-apt-repository --yes --update ppa:git-core/ppa
apt install -qq -y git

# MC for S3
echo ">> minio"
wget -O /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x /usr/local/bin/mc

# yq - jq for yaml
echo ">> yq"
pip install yq


# Cleanup
echo ">> Cleanup"
apt-get clean && rm -rf /var/lib/apt/lists/*