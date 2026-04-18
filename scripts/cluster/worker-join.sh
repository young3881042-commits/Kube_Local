#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./kube.env}"
source "${ENV_FILE}"

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

# CRI 꼬임 방지: 필요하면 주석 해제해서 항상 리셋하도록 쓸 수 있음
# systemctl stop containerd || true
# containerd config default > /etc/containerd/config.toml
# sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
# systemctl enable --now containerd
# systemctl restart containerd

kubeadm join "${API_SERVER}" \
  --token "${TOKEN}" \
  --discovery-token-ca-cert-hash "${CA_HASH}" \
  --cri-socket "${CRI_SOCK}"
