#!/bin/bash
set -euo pipefail

NS="nexus"
SVC="$(kubectl -n ${NS} get svc -o jsonpath='{.items[0].metadata.name}')"

kubectl -n ${NS} patch svc ${SVC} --type='json' -p='[
  {"op":"add","path":"/spec/ports/-","value":{"name":"docker","port":5000,"targetPort":5000,"protocol":"TCP","nodePort":32050}},
  {"op":"replace","path":"/spec/type","value":"NodePort"}
]' || true

kubectl -n ${NS} get svc -o wide
