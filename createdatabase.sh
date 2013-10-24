#!/bin/bash
  
#
# PoC para la creación de las bases de datos
#

function create_query(){
  local DB=${1}
  local USER=${2}
  local PASSWORD=${3}
  cat << __QUERY__ 
CREATE DATABASE ${DB} CHARACTER SET utf8; 
GRANT ALL ON ${DB}.* TO '${USER}'@'%' IDENTIFIED BY '${PASSWORD}';
__QUERY__
}

#
# ~/.temporal_pass tiene que estar creado y es de la forma:
# - mysql:
#   user: root
#   password: $(openssl rand -hex 16)
# - rabbitmq:
#   user: openstack
#   password: $(openssl rand -hex 16)
#

ROOTPASS=$(grep -A2 mysql ~/.temporal_pass | grep password | awk '{print $NF}')
QUERY=$(date +%s).${0##*/}.sql
for DB in keystone glance neutron cinder nova heat
do
  USER=${DB}dbuser
  PASSWORD=${DB}$(openssl rand -hex 8)
  echo -e "- ${DB}:\n\t- ${USER}: ${PASSWORD}" >> ~/.temporal_pass
  create_query ${DB} ${USER} ${PASSWORD} > ${QUERY}
  mysql -u root -p${ROOTPASS} < ${QUERY}
done

rm ${QUERY}
