#!/bin/bash

#---------------------------------------------------------------------------------
#Instalar pi-hole 
#Parar systemd-resolved
#---------------------------------------------------------------------------------
  sudo systemctl disable systemd-resolved.service
  sudo systemctl stop systemd-resolved
#---------------------------------------------------------------------------------
# Agregar DNS TEMPORAL
#---------------------------------------------------------------------------------
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
docker-compose up -d
echo "nameserver 172.20.0.53" >> /etc/resolv.conf

#---------------------------------------------------------------------------------
# Instalar OPENVPN
#----------------------------------------------------------------------------------
docker volume create --name ovpn-data-lg
docker run -v ovpn-data-lg:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -N -d -n 172.20.0.53 -u udp://openvpn.lgroots.xyz -d -s 10.0.250.0/24 -p "dhcp-option DOMAIN lgroots.xyz" -p "route 10.0.0.0 255.255.0.0" -p "route 172.20.0.0 255.255.0.0" -z -C 'AES-256-CBC' -a 'SHA384'
docker run -v ovpn-data-lg:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v ovpn-data-lg:/etc/openvpn --net=nginx_website-net -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn
docker-compose exec -it proxy cp /config/nginx/proxy-confs/portainer.subdomain.conf.sample /config/nginx/site-confs/portainer.lgroots.xyz.conf
docker-compose restart proxy

exit 0