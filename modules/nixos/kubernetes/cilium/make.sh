#/usr/bin/env bash
set -e

VERSION="1.19.2"
NAMESPACE="kube-system"

helm repo update && \
helm template cilium cilium/cilium \
  --version $VERSION \
  --namespace $NAMESPACE \
  -f values.yaml \
  > cilium.yaml
