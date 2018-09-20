#!/usr/bin/env bash

SCRIPT=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$SCRIPT")
BASEDIR=$(realpath "${SCRIPT_DIR}/..")

if [[ ! -z ${1} ]]; then
    PROJECT="my-google-project"
else
    PROJECT="${1}"
fi

cd ${BASEDIR}

# NOTE: make sure you configured Docker to use your Container Registry credentials
# docker build -f viz-json-deploy.Dockerfile -t "gcr.io/${PROJECT}/my-service" .
docker push "gcr.io/${PROJECT}/my-service:latest"