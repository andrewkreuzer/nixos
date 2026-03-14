#/usr/bin/env bash
set -e

VERSION="1.19.1"
NAMESPACE="kube-system"

helm template cilium cilium/cilium \
  --version $VERSION \
  --namespace $NAMESPACE \
  -f values.yaml \
  > cilium.yaml
