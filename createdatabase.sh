#!/bin/bash
#
# mysql -u root -p

# #Keystone
# CREATE DATABASE keystone;
# GRANT ALL ON keystone.* TO 'keystoneUser'@'%' IDENTIFIED BY 'keystonePass';
# 
# #Glance
# CREATE DATABASE glance;
# GRANT ALL ON glance.* TO 'glanceUser'@'%' IDENTIFIED BY 'glancePass';
# 
# #Quantum
# CREATE DATABASE quantum;
# GRANT ALL ON quantum.* TO 'quantumUser'@'%' IDENTIFIED BY 'quantumPass';
# 
# #Nova
# CREATE DATABASE nova;
# GRANT ALL ON nova.* TO 'novaUser'@'%' IDENTIFIED BY 'novaPass';
# 
# #Cinder
# CREATE DATABASE cinder;
# GRANT ALL ON cinder.* TO 'cinderUser'@'%' IDENTIFIED BY 'cinderPass';
# 
# quit;


#
# PoC para la creación de las bases de datos
#

function create_query(){
  local DB=${1}
  local USER=${2}
  local PASSWORD=${3}
  cat << __QUERY__ 
CREATE DATABASE ${DB}; 
GRANT ALL ON ${DB}.* TO '${USER}'@'%' IDENTIFIED BY '${PASSWORD}';
__QUERY__
}

ROOTPASS=${grep -A2 mysql ~/.temporal_pass | grep password | awk '{print $NF}'}
QUERY=$(date +%s).${0##*/}.sql
for DB in keystone glance quantum cinder nova
do
  USER=${DB}dbuser
  PASSWORD=${DB}$(openssl rand -hex 8)
  echo -e "- ${DB}:\n\t- ${USER}: ${PASSWORD}" >> ~/.temporal_pass
  create_query ${DB} ${USER} ${PASSWORD} > ${QUERY}
  echo "mysql -u root -p${ROOTPASS} < ${QUERY}"
done

rm ${QUERY}
