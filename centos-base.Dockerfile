FROM consol/centos-xfce-vnc
ENV REFRESHED_AT 2018-03-18
LABEL maintainer="Dmitriy Repin <drepin@hotmail.com>"

## Install additional developer's tools
USER 0
## Copy the neede configuration files and scripts
RUN mkdir -p /headless/.host_home/
RUN mkdir -p /headless/.vscode/
COPY host_home/* /headless/.host_home/
COPY host_home/bashrc.sh /headless/.bashrc
COPY host_home/bashrc_user.sh /headless/.bashrc_user.sh
RUN chown -R 1000 /headless

## Add VS Code repository
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && mv .host_home/vscode.repo /etc/yum.repos.d/vscode.repo
## Add Google Cloud SDK repository
RUN mv .host_home/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo

# Extra Packages for Enterprise Linux (EPEL) repository. 
RUN yum install -y epel-release

## Setup the IUS public repository on your EL server.
## IUS is a community project that provides RPM packages for newer 
## versions of select software for Enterprise Linux distributions.
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm;

## Install the Software Collections repository for your system
RUN yum install -y centos-release-scl \
    && yum-config-manager --enable rhel-server-rhscl-7-rpms
## See pkgs.org
## Install general development tools
RUN yum install -y \
    build-essential autoconf automake libtool pkg-config \
    gnome-terminal \
    which \
    unzip \
    curl \
    ## The default `git` version is 1.8.3.1. It is too old. Let's install the latest from IUS
    git2u \
    cmake3 \
    ## 4.8.5 (the default version)
    gcc \
    gcc-c++ \
    gdb

## Install extra dev tools
RUN yum install -y gtest-devel

# ## Python 2.7
# RUN yum install -y python python-dev python-pip
# RUN pip install --upgrade virtualenv

## Python 3.4 (python3.4, pip3.4)
RUN yum install -y python34 python34-pip python34-devel

## Python 3.6 (python3.6, pip3.6)
# RUN yum install -y python36u python36u-devel python36u-pip
# RUN ln -s /usr/bin/python3.6 /usr/bin/python3 \
#     && ln -s /usr/bin/pip3.6 /usr/bin/pip3 \
#     && ln -s /usr/bin/python3.6-config /usr/bin/python3-config

# Install python tools
RUN pip3 install --no-cache-dir \
    virtualenv \
    pylint \
    autopep8 \
    rope

## Install CentSO devtoolsets (gcc/gdb/gfortran make pertools valgrind...)
## gcc 5.3.1
# RUN yum install -y devtoolset-4
## gcc 6.3.1
# RUN yum install -y devtoolset-6
## gcc 7.3.1
# RUN yum install -y devtoolset-7
# RUN yum install -y \
#     devtoolset-7-gcc \
#     devtoolset-7-gcc-c++ \
#     devtoolset-7-make \
#     devtoolset-7-gdb \
#     devtoolset-7-gdb-gdbserver 
#
# COPY host_home/enable-devtoolset-7.sh /headless/enable-devtoolset-7.sh
## NOTE: To use `scl enable devtoolset-6 bash` or `source /opt/rh/devtoolset-7/enable`

## Install Google Cloud SDK
RUN yum install -y \
    google-cloud-sdk \
    docker-credential-gcr \
    kubectl
RUN pip3 install --no-cache-dir google-cloud

## Install postman
RUN curl -o /tmp/postman.tar.gz https://dl.pstmn.io/download/latest/linux64 \
    && tmpdir=$(mktemp -d) && mkdir -p $tmpdir \
    && tar xf /tmp/postman.tar.gz -C ${tmpdir} \
    && mv $tmpdir/Postman/app/ /usr/lib64/postman \
    && ln -s /usr/lib64/postman/Postman /usr/bin/postman \
    && rm -rf /tmp/postman.tar.gz $tmpdir

## Install Beyond Compare from www.scootersoftware.com (license required)
RUN wget https://www.scootersoftware.com/bcompare-4.2.6.23150.x86_64.rpm \
    && rpm --import https://www.scootersoftware.com/RPM-GPG-KEY-scootersoftware \
    && yum install -y bcompare-4.2.6.23150.x86_64.rpm

## Install Visual Studio Code and its extensions
# RUN yum -y install code 
## Downgrade the VS Code
RUN wget https://vscode-update.azurewebsites.net/1.24.1/linux-rpm-x64/stable -O code-1.24.1.rpm
RUN yum -y install code-1.24.1.rpm

## Everythng was installed by root, let's allow users to access stuff
# RUN chmod -R a+rwx /headless/.vscode/ /headless/.config/
RUN chmod -R a+rwx /headless/.config/

## Clean
RUN yum clean all

## Install user-specific tools as the user
USER 1000

## Pre-install VS Code plugins
RUN /headless/.host_home/install_vscode_plugins.sh 
