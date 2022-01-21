#!/usr/bin/env bash

export HOME=/root
mkdir $HOME/kube
swapoff -a

function install_docker() {
 echo "Installing Docker..." && \
 curl https://releases.rancher.com/install-docker/20.10.sh | sh && \
 cat << EOF > /etc/docker/daemon.json
 {
   "exec-opts": ["native.cgroupdriver=systemd"]
 }
EOF
}

function enable_docker() {
 systemctl enable docker.service ; \
 systemctl enable containerd.service ; \
 systemctl enable docker ; \
 systemctl restart docker.service ; \
 systemctl restart docker
}

function kube_vip {
  kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://kube-vip.io/manifests/rbac.yaml
  docker run --network host --rm ghcr.io/kube-vip/kube-vip:v0.4.0 manifest daemonset \
  --interface lo \
  --vip ${control_plane_vip} \
  --controlplane \
  --services \
  --bgp \
  --annotations metal.equinix.com \
  --taint \
  --inCluster | kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f -
}

function ceph_pre_check {
  apt install -y lvm2 ; \
  modprobe rbd
}

function install_ccm {
  cat << EOF > $HOME/kube/equinix-ccm-config.yaml
apiVersion: v1
kind: Secret
metadata:
  name: metal-cloud-config
  namespace: kube-system
stringData:
  cloud-sa.json: |
    {
      "apiKey": "${equinix_api_key}",
      "projectID": "${equinix_project_id}",
      "loadbalancer": "${loadbalancer}"
    }
EOF

kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f $HOME/kube/equinix-ccm-config.yaml
RELEASE="temp"
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://github.com/equinix/cloud-provider-equinix-metal/releases/download/$RELEASE/deployment.yaml
}

install_docker && \
enable_docker && \
ceph_pre_check
