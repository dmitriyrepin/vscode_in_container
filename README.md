# VS Code in a container
A Docker container for C++/Python/C# server-side development with Microsoft Visual Studio Code

## Background
https://hub.docker.com/r/consol/centos-xfce-vnc/
https://github.com/ConSol/docker-headless-vnc-container

TODO: Change 'jord-viz-dev'

## Build the enhanced docker image
```bash
docker build -f centos-base.Dockerfile -t gcr.io/jord-viz-dev/drepin-centos-base .
docker build -f centos.Dockerfile -t gcr.io/jord-viz-dev/drepin-centos .
# Run the following command to build a custom docker image
docker build -f centos-user.Dockerfile \
    --build-arg user=${USER} --build-arg uid=$(id -u) --build-arg gid=$(id -g) \
    -t gcr.io/jord-viz-dev/drepin-centos-${USER} .

docker push gcr.io/jord-viz-dev/drepin-centos-base
docker push gcr.io/jord-viz-dev/drepin-centos
docker push gcr.io/jord-viz-dev/drepin-centos-${USER}

```

## Create and run the VNC container
Run command with mapping to local port `5901` (vnc protocol), change the default user within a container to your. 
```Bash
# Get into a new container as root using bash without running the initialization script
docker run -it --rm --user 0 --name centos --entrypoint=/bin/bash gcr.io/jord-viz-dev/drepin-centos
docker run -it --rm --user 0 --name centos-base --entrypoint=/bin/bash gcr.io/jord-viz-dev/drepin-centos-base

# Get into a new container as yourself using bash after running the initialization script
docker run -it --rm --user $(id -u) --name centos gcr.io/jord-viz-dev/drepin-centos bash
# Get into a running container as a root using bash
docker exec -it --user 0 centos bash
```
To avoid loosing your work when the container shuts down, map a `${HOME}/docker-home` directory on the host 
to the `/host` in the container. Do all your work in `/host/`. The VNC password is set to `mylogin`. You need to specify the `--security-opt seccomp=unconfined` option if you plan to do debugging. To enable VNC Viewer client  support, the command below does mapping to local port `5901` (vnc protocol).

```Bash
# Bash: Run interactive VNC session 
# NOTE: plugins are installed on initialization only once if /headless/.vscode is mounted
docker pull gcr.io/jord-viz-dev/drepin-centos
mkdir -p ${HOME}/docker-home; mkdir -p ${HOME}/docker-home/host; mkdir -p ${HOME}/docker-home/vscode
docker run -it --rm -p 5901:5901 -e VNC_PW=mylogin -e VNC_RESOLUTION=2560x1440 --name centos \
    --user $(id -u) \
    --security-opt seccomp=unconfined \
    -v ${HOME}/docker-home/host:/host \
    -v ${HOME}/docker-home/vscode:/headless/.vscode \
    gcr.io/jord-viz-dev/drepin-centos

# Bash: Run interactive VNC session as `drepin`
# NOTE: Plugins are already backed-in into the image, but ${HOME}/docker-home/ will be owned by `drepin`
docker pull gcr.io/jord-viz-dev/drepin-centos
mkdir -p ${HOME}/docker-home; mkdir -p ${HOME}/docker-home/host;
docker run -it --rm -p 5901:5901 -e VNC_PW=mylogin -e VNC_RESOLUTION=2560x1440 --name centos \
    --security-opt seccomp=unconfined \
    -v ${HOME}/docker-home/host:/host \
    gcr.io/jord-viz-dev/drepin-centos-drepin
```

```PowerShell
# PopwerShell: Run interactive VNC session
# NOTE: plugins are installed on initialization only once if /headless/.vscode is mounted
docker pull gcr.io/jord-viz-dev/drepin-centos
mkdir -force ${HOME}/docker-home; mkdir -force ${HOME}/docker-home/host; mkdir -force ${HOME}/docker-home/vscode
docker run -it --rm -p 5901:5901 -e VNC_PW=mylogin -e VNC_RESOLUTION=2560x1440 --name centos `
    --security-opt seccomp=unconfined `
    -v ${HOME}/docker-home/host:/host `
    -v ${HOME}/docker-home/vscode:/headless/.vscode `
    gcr.io/jord-viz-dev/drepin-centos
```

## Connect & Control
If the container is started like mentioned above on a Goolge VM with the local IP 10.128.0.16, connect via one of these options:

* connect via __VNC viewer `10.128.0.16:5901`__, where password: `mylogin`

## Building and debugging

1. Out-of-directory building using CMake:
    (mkdir ../build; cmake -H. -B../build -DCMAKE_BUILD_TYPE=Debug; cd ../build; make)

2. Make sure you set the build type to 'Debug' if you plan debugging. Otherwise, you might get a criptic gdb message

3. Here is an example C++ Lauch Debug configuration. To debugg gdb issues, set `engineLogging` to true
```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        
        {
            "name": "(gdb) Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/src/build/generator",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}/src/build/",
            "environment": [],
            "externalConsole": true,
            "MIMode": "gdb",
            "logging": { "engineLogging": false },
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
}

```

## Hints

    docker rm -f $(docker ps -aq) 
    docker image rm $(docker image ls -aq)
    docker volume rm $(docker volume ls -q)
