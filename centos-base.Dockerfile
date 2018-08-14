FROM consol/centos-xfce-vnc
ENV REFRESHED_AT 2018-03-18
LABEL maintainer="Dmitriy Repin <drepin@hotmail.com>"

## Install additional developer's tools
USER 0
## Copy the neede configuration files and scripts
RUN mkdir -p /headless/.host_home/ && chmod -R a+rwx /headless/.host_home/
COPY host_home/google-cloud-sdk.repo /headless/.host_home/
COPY host_home/vscode.repo /headless/.host_home/
COPY host_home/bashrc.sh /headless/.bashrc
RUN chmod -R a+rx /headless/.bashrc

## Add VS Code repository
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && mv .host_home/vscode.repo /etc/yum.repos.d/vscode.repo
## Add Google Cloud SDK repository
RUN mv .host_home/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo

## Setup the IUS public repository on your EL server.
## IUS is a community project that provides RPM packages for newer 
## versions of select software for Enterprise Linux distributions.
RUN yum -y install https://centos7.iuscommunity.org/ius-release.rpm;

## Install general development tools
RUN yum install -y build-essential autoconf automake libtool pkg-config \
    && yum -y install gnome-terminal \
    && yum -y install which \
    && yum -y install uuid \
    && yum -y install curl \
    ## The default `git` version is 1.8.3.1. It is too old. Let's install the latest from IUS
    && yum install -y git2u \
    # && yum -y install glog \
    # && yum -y install gmock \
    && yum -y install cmake \
    ## 4.8.5 (the default version)
    && yum -y install gcc \
    && yum -y install gcc-c++ \
    && yum -y install gdb \
    # && yum -y install boost-1.53.0 \
    && yum -y install openssl \
    && yum -y install ca-certificates

## Install CentSO devtoolsets (gcc/gdb/gfortran make pertools valgrind...)
## gcc 5.3.1
# RUN yum install -y devtoolset-4
## gcc 6.3.1
# RUN yum install -y devtoolset-6
## gcc 7.3.1
# RUN yum install -y devtoolset-6

## Install Google Cloud SDK
RUN yum install -y \
    google-cloud-sdk \
    docker-credential-gcr  

## Install Visual Studio Code and its extensions
RUN yum -y install code

## Everythng was installed by root, let's allow users to access stuff
# RUN chmod -R a+rwx /headless/.vscode/ /headless/.config/
RUN chmod -R a+rwx /headless/.config/

RUN yum clean all

USER 1000
