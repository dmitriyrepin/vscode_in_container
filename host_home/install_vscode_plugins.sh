#!/usr/bin/env bash
#
# NOTE: This script will run using the current user Id 
#

### every exit != 0 fails the script
set -e

if [ -f /headless/.vscode/__extensions_installed.txt ]; then
    echo "Nothing to do: VS Code plugins have already been installed"
else
    echo "Installing VS Code plugins"
    code --user-data-dir /headless/.vscode/extensions --install-extension ms-vscode.cpptools
    code --user-data-dir /headless/.vscode/extensions --install-extension twxs.cmake
    code --user-data-dir /headless/.vscode/extensions --install-extension vector-of-bool.cmake-tools
    code --user-data-dir /headless/.vscode/extensions --install-extension msjsdiag.debugger-for-chrome
    code --user-data-dir /headless/.vscode/extensions --install-extension peterjausovec.vscode-docker
    code --user-data-dir /headless/.vscode/extensions --install-extension donjayamanne.githistory
    code --user-data-dir /headless/.vscode/extensions --install-extension ms-python.python
    code --user-data-dir /headless/.vscode/extensions --install-extension zxh404.vscode-proto3
    code --user-data-dir /headless/.vscode/extensions --install-extension eamodio.gitlens

    touch /headless/.vscode/__extensions_installed.txt
fi
