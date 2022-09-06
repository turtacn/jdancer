FROM ubuntu:focal
SHELL ["/bin/bash", "-c"]
# Install baseline packages
RUN apt-get update && \
 DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
 apt-transport-https \
 bash \
 build-essential \
 ca-certificates \
 curl \
 dbus \
 dnsutils \
 docker.io \
 gnupg-agent \
 htop \
 iptables \
 iproute2 \
 iputils-ping \
 jq \
 kmod \
 libsystemd0 \
 locales \
 lsb-release \
 man \
 openssh-server \
 python3 \
 python3-pip \
 rsyslog \
 software-properties-common \
 sudo \
 systemd \
 systemd-sysv \
 udev \
 unzip \
 vim \
 wget && \
 # Install Docker using official repository
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add — && \
 apt-key fingerprint 0EBFCD88 && \
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
 apt-get update && apt-get install --no-install-recommends --yes \
 docker-ce \
 docker-ce-cli \
 containerd.io && \
 # Install latest Git using their official PPA
 add-apt-repository ppa:git-core/ppa && \
 DEBIAN_FRONTEND="noninteractive" apt-get install --yes git && \
 # Housekeeping
 apt-get autoremove --yes && \
 apt-get clean --yes && \
 rm -rf \
 /tmp/* \
 /var/lib/apt/lists/* \
 /var/tmp/*
# Prevents journald from reading kernel messages from /dev/kmsg
RUN echo "ReadKMsg=no" >> /etc/systemd/journald.conf
# Create default ‘admin/admin’ user
RUN useradd admin \
 --create-home \
 --shell /bin/bash \
 --groups docker \
 --uid=1000 \
 --user-group && \
 echo "admin:admin" | chpasswd && \
 echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/admin && \
 mkdir /home/admin/.ssh && \
 chown admin:admin /home/admin/.ssh
# Make use of stopsignal (instead of sigterm) to stop systemd containers.
STOPSIGNAL SIGRTMIN+3
# Expose OpenSSH server
EXPOSE 22
# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", " — log-level=err" ]
