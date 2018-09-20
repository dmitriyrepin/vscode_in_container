#!/usr/bin/env bash

if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then 
    echo "*** ERROR: this script must be sourced ..."
    exit -1
fi

SCRIPT=$(readlink -f "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "$SCRIPT")
BASEDIR=$(realpath "${SCRIPT_DIR}/..")

NEW_PYTHONPATH="${BASEDIR}/src/code:${BASEDIR}/src/generated:${BASEDIR}/src/tests"
if [[ ! -z ${PYTHONPATH} ]]; then
    NEW_PYTHONPATH="${PYTHONPATH}:${NEW_PYTHONPATH}"
fi
export PYTHONPATH=${NEW_PYTHONPATH}

NEW_LIBRARY_PATH="${BASEDIR}/../external/bin/"
if [[ ! -z ${LD_LIBRARY_PATH} ]]; then
    NEW_LIBRARY_PATH="${LD_LIBRARY_PATH}:${NEW_LIBRARY_PATH}"
fi
export LD_LIBRARY_PATH=${NEW_LIBRARY_PATH}


export PYTHONDONTWRITEBYTECODE="YES"

