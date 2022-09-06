# 以root用户安装为例
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
 
 
yum-config-manager \
  --add-repo \
  http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
   
yum install docker-ce docker-ce-cli containerd.io -y
 
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
 
 
# 新建和修改containerd配置
containerd config default > /etc/containerd/config.toml
sed  -i 's/k8s.gcr.io\/pause/registry.aliyuncs.com\/google_containers\/pause/g' /etc/containerd/config.toml
 
# 关闭防火墙
systemctl stop firewalld
# 关闭swap
swapoff -a
# 关闭selinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
modprobe br_netfilter
modprobe nf_conntrack
sysctl net.bridge.bridge-nf-call-iptables=1
echo "1" > /proc/sys/net/ipv4/ip_forward
 
# 指定版本安装k8s套件
yum install -y kubelet-1.24.3 kubeadm-1.24.3 kubectl-1.24.3
 
 
# 服务设置
systemctl daemon-reload
systemctl disable firewalld
systemctl enable kubelet
systemctl enable containerd && systemctl start containerd
 
# 构建单master
kubeadm init \
    --image-repository registry.aliyuncs.com/google_containers
 
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
