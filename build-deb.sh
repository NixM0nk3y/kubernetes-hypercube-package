#!/bin/bash
#
#
#

VERSION="1.11.2"
BUILD="openenterprise1"
CONTACT="Nick Gregory <package@openenterprise.co.uk>"
PACKAGE_NAME="kubernetes-hyperkube"

HYPERCUBE_IMAGE=${VARIABLE:-gcr.io/google-containers/hyperkube-arm:v1.11.2}

DIRNAME="$(cd "$(dirname "$0")" && pwd)"
OLDESTPWD="$PWD"

mkdir ./tmp

docker run --rm -v $(pwd)/tmp:/tmp/hyperkube --entrypoint cp ${HYPERCUBE_IMAGE} -vr /hyperkube /tmp/hyperkube

rm -rf "$PWD/rootfs"

mkdir -p "$PWD/rootfs/usr/bin"

mv "$PWD/tmp/hyperkube" "$PWD/rootfs/usr/bin/"

fakeroot fpm -C "$PWD/rootfs" \
    --license "Apache" \
    --url "https://github.com/kubernetes/kubernetes" \
    --vendor "" \
    --description "Kubernetes is an open source system for managing containerized applications across multiple hosts; providing basic mechanisms for deployment, maintenance, and scaling of applications." \
    -m "${CONTACT}" \
    -n "${PACKAGE_NAME}" -v "$VERSION-$BUILD" \
    -p "$OLDESTPWD/${PACKAGE_NAME}_${VERSION}-${BUILD}_armhf.deb" \
    -s "dir" -t "deb" \
"usr"

rm -rf ./tmp
rm -rf "$PWD/rootfs"
