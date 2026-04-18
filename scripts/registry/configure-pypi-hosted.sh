#!/bin/bash
set -euo pipefail

NEXUS_NS="${NEXUS_NS:-nexus}"
NEXUS_NODE_IP="${NEXUS_NODE_IP:-192.168.45.101}"
NEXUS_WEB_PORT="${NEXUS_WEB_PORT:-32457}"
NEXUS_URL="http://${NEXUS_NODE_IP}:${NEXUS_WEB_PORT}"
REPO_NAME="${REPO_NAME:-pypi-hosted}"

PASS="$(kubectl -n "${NEXUS_NS}" exec deploy/nexus-nexus-repository-manager -- cat /nexus-data/admin.password)"

if kubectl -n "${NEXUS_NS}" exec deploy/nexus-nexus-repository-manager -- \
  sh -c "curl -fsS -u admin:${PASS} http://127.0.0.1:8081/service/rest/v1/repositories" | \
  grep -q "\"name\" : \"${REPO_NAME}\""; then
  echo "[skip] ${REPO_NAME} already exists"
  exit 0
fi

kubectl -n "${NEXUS_NS}" exec deploy/nexus-nexus-repository-manager -- sh -c 'cat <<EOF >/tmp/pypi-hosted.json
{
  "name": "'"${REPO_NAME}"'",
  "online": true,
  "storage": {
    "blobStoreName": "default",
    "strictContentTypeValidation": true,
    "writePolicy": "allow"
  }
}
EOF
curl -fsS -u admin:'"${PASS}"' \
  -H "Content-Type: application/json" \
  -X POST \
  http://127.0.0.1:8081/service/rest/v1/repositories/pypi/hosted \
  --data @/tmp/pypi-hosted.json'

echo "[done] created ${REPO_NAME}"
echo "[info] upload endpoint: ${NEXUS_URL}/repository/${REPO_NAME}/"
