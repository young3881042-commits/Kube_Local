#!/bin/bash
set -euo pipefail

NEXUS_NODE_IP="${NEXUS_NODE_IP:-192.168.45.101}"
NEXUS_WEB_PORT="${NEXUS_WEB_PORT:-32457}"
REPO_NAME="${REPO_NAME:-pypi-hosted}"
NEXUS_USER="${NEXUS_USER:-admin}"
NEXUS_PASS="${NEXUS_PASS:?set NEXUS_PASS}"
DIST_DIR="${DIST_DIR:-/apps/kube_shell/04.registry_nexus/pypi-demo/dist}"
API_URL="http://${NEXUS_NODE_IP}:${NEXUS_WEB_PORT}/service/rest/v1/components?repository=${REPO_NAME}"

if [ ! -d "${DIST_DIR}" ]; then
  echo "[error] DIST_DIR not found: ${DIST_DIR}" >&2
  exit 1
fi

shopt -s nullglob
FILES=("${DIST_DIR}"/*.tar.gz "${DIST_DIR}"/*.whl)
shopt -u nullglob

if [ "${#FILES[@]}" -eq 0 ]; then
  echo "[error] no .tar.gz or .whl files found in ${DIST_DIR}" >&2
  exit 1
fi

for file in "${FILES[@]}"; do
  echo "[upload] ${file}"
  curl -fsS -u "${NEXUS_USER}:${NEXUS_PASS}" \
    -F "pypi.asset=@${file}" \
    "${API_URL}" \
    -D -
done

echo "[done] uploaded ${#FILES[@]} file(s) to ${REPO_NAME}"
