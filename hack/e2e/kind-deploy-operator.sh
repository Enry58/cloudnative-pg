#!/usr/bin/env bash

##
## This file is part of Cloud Native PostgreSQL.
##
## Copyright (C) 2019-2020 2ndQuadrant Italia SRL. Exclusively licensed to 2ndQuadrant Limited.
##

# standard bash error handling
set -eEuo pipefail

KIND_CLUSTER_NAME=${1}
DEBUG=${DEBUG:-false}
BUILD_IMAGE=${BUILD_IMAGE:-true}
OPERATOR_IMG="quay.io/2ndquadrant/cloud-native-postgresql-operator:e2e"
POSTGRES_IMG="quay.io/2ndquadrant/cloud-native-postgresql:12"
ROOT_DIR=$(realpath "$(dirname "$0")/../../")

if [ "${DEBUG}" = true ]
then
    set -x
fi

build_and_load_operator() {
    docker build -t "${OPERATOR_IMG}" "${ROOT_DIR}"
    kind load -v 1 docker-image --name "${KIND_CLUSTER_NAME}" "${OPERATOR_IMG}"
}

build_and_load_postgres() {
    docker build -t "${POSTGRES_IMG}" -f "${ROOT_DIR}/Dockerfile-postgresql"  "${ROOT_DIR}"
    kind load -v 1 docker-image --name "${KIND_CLUSTER_NAME}" "${POSTGRES_IMG}"
}

upload_image_to_kind() {
    SRC_IMG=$1
    DST_IMG=${2:-${SRC_IMG}}
    if [[ "$(docker images -q "${SRC_IMG}" 2> /dev/null)" == "" ]]
    then
        docker pull "${SRC_IMG}"
    fi
    [ "${SRC_IMG}" = "${DST_IMG}" ] || docker tag "${SRC_IMG}" "${DST_IMG}"
    kind load -v 1 docker-image --name "${KIND_CLUSTER_NAME}" "${DST_IMG}"
    [ "${SRC_IMG}" = "${DST_IMG}" ] || docker rmi "${DST_IMG}"
}

# Deploy the operator and wait for the deployment to be complete
deploy_operator() {
    make -C "${ROOT_DIR}" deploy CONTROLLER_IMG="${OPERATOR_IMG}"
    kubectl wait --for=condition=Available --timeout=2m \
      -n postgresql-operator-system deployments \
      postgresql-operator-controller-manager
}

main() {
    if [ "${BUILD_IMAGE}" != false ]
    then
        build_and_load_operator
        build_and_load_postgres
    else
        upload_image_to_kind "${CONTROLLER_IMG}" "${OPERATOR_IMG}"
        upload_image_to_kind "${POSTGRES_IMG}"
    fi
    deploy_operator
}

main