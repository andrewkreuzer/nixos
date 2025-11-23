#/usr/bin/env bash
set -e

VERSION="1.18.7"
BASE_URL="https://raw.githubusercontent.com/rook/rook"

FILES=(
  crds.yaml
  common.yaml
  csi-operator.yaml
  operator.yaml
)

for FILE in "${FILES[@]}"; do
  curl -fsSL \
    "$BASE_URL/release-${VERSION%.*}/deploy/examples/$FILE" -o install/$FILE
done

kubectl kustomize install/ > rook-ceph.yaml

helm template rook-ceph-cluster rook-release/rook-ceph-cluster \
  --namespace rook-ceph \
  --version $VERSION \
  -f values.yaml \
  | yq eval-all '.metadata.labels["addonmanager.kubernetes.io/mode"] = "Reconcile"' - \
  > rook-ceph-cluster.yaml

