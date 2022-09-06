#!/usr/bin/sh
k8s_version=$1
flannel_version=$2
# Start containerd
containerd &
containerd_pid=$!
sleep 2
# Pull k8s images
kubeadm config images list --kubernetes-version=$k8s_version | xargs -n 1 ctr images pull
# Pull Flannel CNI images
ctr images pull docker.io/rancher/mirrored-flannelcni-flannel-cni-plugin:v1.0.0
ctr images pull quay.io/coreos/flannel:$flannel_version
# List pulled images
ctr images list
# Stop containerd
kill $containerd_pid
