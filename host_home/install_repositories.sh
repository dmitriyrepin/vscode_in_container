#!/usr/bin/env bash

# set -ex

## Add VS Code repository
rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && cp /headless/.host_home/vscode.repo /etc/yum.repos.d/vscode.repo
## Add Google Cloud SDK repository
cp /headless/.host_home/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo

# Extra Packages for Enterprise Linux (EPEL) repository. 
yum install -y epel-release

## Setup the IUS public repository on your EL server.
## IUS is a community project that provides RPM packages for newer 
## versions of select software for Enterprise Linux distributions.
yum install -y https://centos7.iuscommunity.org/ius-release.rpm;

## Install the Software Collections repository for your system
yum install -y centos-release-scl \
    && yum-config-manager --enable rhel-server-rhscl-7-rpms