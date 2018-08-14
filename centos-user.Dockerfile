## USAGE:
## docker build -f centos-user.Dockerfile \
##    --build-arg user=${USER} --build-arg uid=$(id -u) --build-arg gid=$(id -g) \
##    -t drepin/centos-${USER} .
## docker push gcr.io/drepin/centos-${USER}
##
## TODO: Change this
FROM gcr.io/jord-viz-dev/drepin-centos-base
LABEL maintainer="Dmitriy Repin <drepin@hotmail.com>"

ARG user
ARG uid
ARG gid

USER 0

RUN mkdir -p /headless/.vscode/ && chmod -R a+rwx /headless/.vscode/
COPY host_home/install_vscode_plugins.sh /headless/.host_home/install_vscode_plugins.sh
RUN chmod -R a+rx /headless/.host_home/install_vscode_plugins.sh

RUN echo "$user:$user\!:$uid:$gid::/home/$user:/bin/bash" | newusers

## Install user-specific tools as the user
USER $user

## Copy Shell customizations
COPY host_home/bashrc_user.sh /headless/.bashrc_user.sh

## Pre-install VS Code plugins
RUN /headless/.host_home/install_vscode_plugins.sh
