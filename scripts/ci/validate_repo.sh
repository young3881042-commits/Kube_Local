#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

echo "[validate] 핵심 문서 확인"
test -f README.md
test -f docs/overview.md
test -f docs/jenkins.md
test -f env/cluster.env.example
test -f env/jenkins.env.example

echo "[validate] 스크립트 문법 확인"
while IFS= read -r script; do
  bash -n "$script"
done < <(find scripts -type f -name '*.sh' | sort)

echo "[validate] 매니페스트 확인"
find manifests -type f \( -name '*.yaml' -o -name '*.yml' \) | sort | while IFS= read -r manifest; do
  test -s "$manifest"
done

echo "[validate] 완료"
