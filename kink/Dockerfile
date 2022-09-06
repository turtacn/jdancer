FROM sysbox-base
ARG k8s_version=v1.20.12
ARG flannel_version=v0.15.1
# Disable Docker
RUN systemctl disable docker.service docker.socket \
    && rm -f /etc/containerd/config.toml
# Install kubeadm, kubelet
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add    \
    && apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"        \
    && apt-get update && apt-get install --no-install-recommends -y                     \
       kubeadm="${k8s_version#v}"-00 kubelet="${k8s_version#v}"-00                      \
    && rm -rf /var/lib/apt/lists/*
# Pre-pull Kubernetes images
COPY k8s-pull.sh /usr/bin/
RUN chmod +x /usr/bin/k8s-pull.sh && k8s-pull.sh $k8s_version $flannel_version && rm /usr/bin/k8s-pull.sh
