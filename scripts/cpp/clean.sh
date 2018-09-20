#!/usr/bin/env bash

if [ ! -d ./py_code ] && [ ! -d ./cpp_code ]; then
    echo "***ERROR: The script must be run from the workspace root folder"
    exit 1
fi 

rm -rf _builds
rm -rf _deploy