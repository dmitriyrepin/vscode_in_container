#!/usr/bin/env bash

# You can enable the following option for debugging
# set -ex
build_type = ${1}
if [ -z "$build_type" ]; 
    build_type="Debug"
fi

if [ ! -d ./py_code ] && [ ! -d ./cpp_code ]; then
    echo "***ERROR: The script must be run from the workspace root folder"
    exit 1
fi 

echo "Setting the environement"
export ROOT_DIR=`pwd`

cd viz-json
echo "Setting the environement"
source /headless/.host_home/enable-devtoolset-7.sh

echo "Building '${build_type}' configuration..."
mkdir -p ../_builds/${build_type}
cmake3 -H. -B../_builds/${build_type} -DCMAKE_BUILD_TYPE=${build_type}
cmake3 --build ../_builds/${build_type} --config ${build_type} --target all -- -j
cmake3 --build ../_builds/${build_type} --config ${build_type} --target install

export ARTIFACT_DIR="${ROOT_DIR}/_deploy"
echo "Deploying artifacts ${ARTIFACT_DIR}.."
#
# C++
#
mkdir -p ${ARTIFACT_DIR}/bin
cp -r --preserve=links ../external/bin/* ${ARTIFACT_DIR}/bin
cd ..
#
# Python
#
cd py-server/
mkdir -p ${ARTIFACT_DIR}/py