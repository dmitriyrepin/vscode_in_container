## TODO: Change this
FROM gcr.io/jord-viz-dev/drepin-centos-base
LABEL maintainer="Dmitriy Repin <drepin@hotmail.com>"

USER 0

RUN mkdir -p /headless/.vscode/ && chmod -R a+rwx /headless/.vscode/
COPY host_home/install_vscode_plugins.sh /headless/.host_home/install_vscode_plugins.sh
RUN chmod -R a+rx /headless/.host_home/install_vscode_plugins.sh

USER 1000

## Copy Shell customizations
COPY host_home/bashrc_user.sh /headless/.bashrc_user.sh
