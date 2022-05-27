#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt install -y git ca-certificates gcc libc6-dev liblua5.3-dev libpcre3-dev libssl-dev libsystemd-dev make wget zlib1g-dev socat


# Install OpenSSL-quic
cd ~
git clone https://github.com/quictls/openssl
cd openssl
mkdir -p /opt/quictls/ssl
./Configure --libdir=lib --prefix=/opt/quictls
make
sudo make install
echo /opt/quictls/lib | sudo tee -a /etc/ld.so.conf
sudo ldconfig

# Install HAProxy
cd ~
git clone https://github.com/haproxy/haproxy.git
cd haproxy
sudo make -j $(nproc) \
  TARGET=linux-glibc \
  USE_LUA=1 \
  USE_OPENSSL=1 \
  USE_PCRE=1 \
  USE_ZLIB=1 \
  USE_SYSTEMD=1 \
  USE_PROMEX=1 \
  USE_QUIC=1 \
  SSL_INC=/opt/quictls/include \
  SSL_LIB=/opt/quictls/lib \
  LDFLAGS="-Wl,-rpath,/opt/quictls/lib"

sudo make install-bin 

# Enable systemd service
cd admin/systemd
sudo make haproxy.service
sudo cp ./haproxy.service /etc/systemd/system/

mkdir -p /etc/haproxy
mkdir -p /run/haproxy
touch /etc/haproxy/haproxy.cfg

systemctl enable haproxy
systemctl start haproxy


# Install Docker
if [ ! $(which docker) ]; then
  sudo apt update
  sudo DEBIAN_FRONTEND=noninteractive apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo DEBIAN_FRONTEND=noninteractive apt update
  sudo DEBIAN_FRONTEND=noninteractive apt install -y docker-ce
  sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo "docker already installed."
fi

# # Start web app
cd /vagrant/web
sudo docker-compose up -d

/vagrant/reload.sh