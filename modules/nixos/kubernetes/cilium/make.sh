#/usr/bin/env bash
set -e

VERSION="1.18.3"
NAMESPACE="kube-system"

helm template cilium cilium/cilium \
  --version $VERSION \
  --namespace $NAMESPACE \
  -f values.yaml \
  > cilium.yaml
