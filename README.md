# VS Code in a container
A Docker container for C++/Python/C# server-side development with Microsoft Visual Studio Code

## Background
https://hub.docker.com/r/consol/centos-xfce-vnc/
https://github.com/ConSol/docker-headless-vnc-container

## Build the docker image
```bash
# Configured Docker to use gcloud as a credential helper (do this once): 
gcloud auth configure-docker

# Makee sure to use the project is, not the project name
docker build -f centos-base.Dockerfile -t gcr.io/my-google-project-id/centos-base .
docker push gcr.io/my-google-project-id/centos-base
```

## Create and run the VNC container
Create a container from the image. 
* Make sure to map the local port `5901` (used by the vnc protocol) to enable connecting with a VNC Viewer client.
* Specify the VNC password as a command line option (e.g, `mylogin` below).
* To avoid loosing your work when the container shuts down, map the `${HOME}/docker-home` directory on the host 
to the `/host` in the container. Do all the work that needs to be persisted in the `/host/`. 
* You need to specify the `--security-opt seccomp=unconfined` option if you plan to do C/C++ debugging. 
```Bash
# Bash: Run an interactive VNC session 
docker pull gcr.io/my-google-project/drepin-centos
# Make sure the host is owned by the user 1000
mkdir -p ${HOME}/docker-home/host; chown 1000 ${HOME}/docker-home/host
docker run -it --rm --name centos \
    -p 5901:5901 -e VNC_PW=mylogin -e VNC_RESOLUTION=2560x1440 \
    --security-opt seccomp=unconfined \
    -v ${HOME}/docker-home/host:/host \
    -v config:/headless/.config \
    gcr.io/my-google-project/drepin-centos
```

For security reasons, by the default, the container will run as the user 1000. You will have a permission to modify the system (e.g., to run 'yum install'). 

If you need to permor an action requiring an elevated permissions, you can connect to the running container as a root using bash
```Bash
docker exec -it --user 0 centos-base bash
```

## Connect & Control
If the container is started like mentioned above on a Goolge VM with the local IP 10.128.0.16, connect to it via one of these options:

* connect via __VNC viewer `10.128.0.16:5901`__, where password: `mylogin`

## Building and debugging

* After performaing 'git clone' in a container, don't forget to set your infor. You will need it for 'git push'

        git config user.email "drepin@hotmail.com"
        git config user.name "Dmitriy Repin"

* C/C++: out-of-directory building using CMake:
    (mkdir ../build; cmake -H. -B../build -DCMAKE_BUILD_TYPE=Debug; cd ../build; make)

* C/C++: Make sure you set the build type to 'Debug' if you plan debugging. Otherwise, you might get a criptic gdb message

* C++: example C++ Launch Debug configuration. To debugg gdb issues, set `engineLogging` to true
```json
{
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

* Python: remove pycache 

        find ./ -name "__pycache__" -exec rm -rf {} \;
        find ./ -name ".pytest_cache" -exec rm -rf {} \;

* Python: AN example of Launch Debug configuration
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: main.py",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/src/main.py",
            "console": "integratedTerminal"
        },
        {
            "name": "Python: run_tests.py",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/src/run_tests.py",
            "console": "integratedTerminal",
        }
    ]
}
```

## Miscellaneous

Misc docker commands

        docker rm -f $(docker ps -aq) 
        docker image rm $(docker image ls -aq)
        docker volume rm $(docker volume ls -q)

To change resolution on the fly, run `xrandr` to see the available modes. Then run

        xrandr -s 1280x800
        xrandr -s 1920x1200
        xrandr -s 2560x1440

VS Code settings
```json
{
    "editor.autoClosingBrackets": false,
    "editor.detectIndentation": false,
    "editor.minimap.enabled": false,
    // "editor.formatOnSave": true,
    // "editor.formatOnType": true,
    // "editor.formatOnPaste": true,
    // "[dockerfile]": {
    //     "editor.formatOnSave": false,
    // },
    "git.enableSmartCommit": true,
    "extensions.ignoreRecommendations": true,
    "python.pythonPath": "/usr/bin/python3",
    "python.linting.pylintArgs": [
        "--max-line-length=120",
        "--disable=missing-docstring",
        "--disable=unused-variable",
        "--disable=unused-argument",
        "--disable=trailing-whitespace"
    ],
    "python.formatting.autopep8Args": [
        "--max-line-length=120"
    ]
}
```
