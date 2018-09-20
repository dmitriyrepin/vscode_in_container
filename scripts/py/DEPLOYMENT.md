# SETING UP A CI BUILD WITH MICROSOFT VSTS

## Setup a Linux build machine
Loging into your build machine and setuo a package repository
```Bash
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

## Install the Docker CE on the build machine
```Bash
sudo apt-get update
sudo apt-get install -y docker-ce
```
Enable managing Docker as a non-root user
```Bash
sudo groupadd docker
sudo usermod -aG docker $USER
# Make sure <LOGOUT> and <LOGIN>
```
Configure Docker to start on boot
```Bash
sudo systemctl enable docker
```

## Configure the Container Registry authorization

The VM has a Google SDK installed and the installation can't be modified, i.e., the following will NOT work
```Bash
    gcloud components install docker-credential-gcr
    gcloud auth configure-docker
```
So, we install a standalone Docker credential helper
https://cloud.google.com/container-registry/docs/advanced-authentication
```Bash
# Install a standalone Docker credential helper (docker-credential-gcr)
curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v1.5.0/docker-credential-gcr_linux_amd64-1.5.0.tar.gz" > /tmp/docker-credential-gcr.tar.gz
cd /tmp && tar xvf docker-credential-gcr.tar.gz
sudo mv docker-credential-gcr /usr/bin/docker-credential-gcr 
sudo chmod +x /usr/bin/docker-credential-gcr
# Configure Docker to use your Container Registry credentials (only need to do this once)
docker-credential-gcr configure-docker
```

## Setup a CI build in VSTS

0. Read https://docs.microsoft.com/en-us/vsts/pipelines/agents/v2-linux?view=vsts
1. Created new `viz-json` agent pool
2. Create personal access token (see https://docs.microsoft.com/en-us/vsts/pipelines/agents/v2-linux?view=vsts)
3. VSTS -> Agent pools -> Download agent. Select Linux tab and copy the agent download URL
4. Login to the build machine 
```Bash
# Instal the agent
mkdir ~/vsts && cd ~/vsts
wget https://vstsagentpackage.azureedge.net/agent/2.139.1/vsts-agent-linux-x64-2.139.1.tar.gz
tar zxvf vsts-agent-linux-x64-2.139.1.tar.gz
rm vsts-agent-linux-x64-2.139.1.tar.gz
# Configure the agent
sudo ./bin/installdependencies.sh
./config.sh
# Use 
# Server URL: `https://slb-swt.visualstudio.com` 
# Authentication type: `PAT`
# Personal access token:  (see setp 3 abotve) The personal access token is one-use
# Agent pool: `my-service`
# Agent name: `drepin-viz-json-build-agent` (this is the build VM name)
# Work folder: `_work`
```
5. To start the service manually
```
~/vsts/run.sh
```

6. Start service automatically
```Bash
sudo ./svc.sh install
sudo ./svc.sh start
# Run as user: drepin
# Run as uid: 1019
# gid: 1020
sudo ./svc.sh status
```

## Manually running tests
Add read ermission to the build VM service account to
123456789-compute@developer.gserviceaccount.com

```Bash
# 
docker pull gcr.io/cds-dev-155819/my-service
docker run -it --rm -p 8080:8080 --name my-service-test gcr.io/cds-dev-155819/my-service bash
docker exec -it --user 0 my-service-test bash
```