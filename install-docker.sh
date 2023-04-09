#!/bin/bash

#---------------------------------------------------------------------------------
#Instalar Docker 
#---------------------------------------------------------------------------------

# Crear directorio temporal que no se borra
mkdir -p ./temp && cd temp

# Version actualizada de docker script
curl -fsSL https://get.docker.com -o get-docker.sh

# corre el script 
sudo sh get-docker.sh

# Agrega el usuario actual al grupo docker
sudo usermod -aG docker $USER

#---------------------------------------------------------------------------------
# Instalar Docker Compose
#---------------------------------------------------------------------------------

COMPOSE_VERSION=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
AUTO_COMPLETE_COMPOSE_VERSION=1.29.2

# Descargar la ultima version de docker
sudo curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

# Aplicar permisos
sudo chmod +x /usr/local/bin/docker-compose

# Instalar completo
sudo curl -L https://raw.githubusercontent.com/docker/compose/$AUTO_COMPLETE_COMPOSE_VERSION/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

#---------------------------------------------------------------------------------
# Ver version
#---------------------------------------------------------------------------------
docker version
docker-compose version

exit 0