# Docker container that installs Ansible, Ansistrano, and dependencies

FROM debian:buster

MAINTAINER keopx <keopx@keopx.net>

ENV DEBIAN_FRONTEND noninteractive

# Set repositories
RUN \
  echo "deb http://ftp.de.debian.org/debian/ buster main non-free contrib" > /etc/apt/sources.list && \
  echo "deb-src http://ftp.de.debian.org/debian/ buster main non-free contrib" >> /etc/apt/sources.list && \
  echo "deb http://security.debian.org/ buster/updates main contrib non-free" >> /etc/apt/sources.list && \
  echo "deb-src http://security.debian.org/ buster/updates main contrib non-free" >> /etc/apt/sources.list && \
  # Update repositories cache and distribution
  apt-get -qq update && apt-get -qqy upgrade && \
  apt-get -yqq install apt-transport-https lsb-release ca-certificates gnupg2 openssl wget dirmngr software-properties-common && \
  echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" >> /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
  apt-get update && \
  apt-get install -y ansible openssh-client rsync && \
  rm -rf /var/lib/apt/lists/*
RUN ansible-galaxy install --force ansistrano.deploy ansistrano.rollback && \
  echo "[defaults]" >> /etc/ansible/ansible.cfg && \
  echo "host_key_checking = False" >> /etc/ansible/ansible.cfg

CMD ["bash"]
