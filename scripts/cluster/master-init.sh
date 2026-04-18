#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./kube.env}"
source "${ENV_FILE}"

# CRI 소켓 선택
choose_cri_sock() {
  case "${CRI_SOCKET_MODE:-auto}" in
    run)    [[ -S /run/containerd/containerd.sock ]] && echo "unix:///run/containerd/containerd.sock" && return 0 ;;
    varrun) [[ -S /var/run/containerd/containerd.sock ]] && echo "unix:///var/run/containerd/containerd.sock" && return 0 ;;
    auto|*)
      [[ -S /run/containerd/containerd.sock ]] && echo "unix:///run/containerd/containerd.sock" && return 0
      [[ -S /var/run/containerd/containerd.sock ]] && echo "unix:///var/run/containerd/containerd.sock" && return 0
      ;;
  esac
  return 1
}

CRI_SOCK="$(choose_cri_sock)" || { echo "[ERROR] containerd socket not found."; exit 1; }

systemctl enable --now containerd
systemctl is-active --quiet containerd

kubeadm reset -f || true
rm -rf /etc/cni/net.d "$HOME/.kube" || true
systemctl restart containerd

kubeadm init --pod-network-cidr="${POD_CIDR}" --cri-socket="${CRI_SOCK}"

mkdir -p "$HOME/.kube"
cp -f /etc/kubernetes/admin.conf "$HOME/.kube/config"
chmod 600 "$HOME/.kube/config"

kubectl apply -f "${CNI_URL}"
kubectl get nodes -o wide
