## 👋 Welcome to ifconfig 🚀  

ifconfig README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update ifconfig
```
  
## Install and run container
  
```shell
dockerHome="/var/lib/srv/$USER/docker/casjaysdevdocker/ifconfig/ifconfig/latest/rootfs"
mkdir -p "/var/lib/srv/$USER/docker/ifconfig/rootfs"
git clone "https://github.com/dockermgr/ifconfig" "$HOME/.local/share/CasjaysDev/dockermgr/ifconfig"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/ifconfig/rootfs/." "$dockerHome/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-ifconfig-latest \
--hostname ifconfig \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$dockerHome/data:/data:z" \
-v "$dockerHome/config:/config:z" \
-p 80:80 \
casjaysdevdocker/ifconfig:latest
```
  
## via docker-compose  
  
```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/ifconfig
    container_name: casjaysdevdocker-ifconfig
    environment:
      - TZ=America/New_York
      - HOSTNAME=ifconfig
    volumes:
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/ifconfig/ifconfig/latest/rootfs/data:/data:z"
      - "/var/lib/srv/$USER/docker/casjaysdevdocker/ifconfig/ifconfig/latest/rootfs/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/ifconfig
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/ifconfig" "$HOME/Projects/github/casjaysdevdocker/ifconfig"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/ifconfig"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  
