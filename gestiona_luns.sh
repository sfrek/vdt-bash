#!/bin/bash
#
# script creado para generar los "igroup" y "mapear" "luns"
#
# autor: Fernando Israel García Martínez ( figarciamartinez@gmail.com )
# motivación: El ¿ pór qué ? de este es script es sencillo PoC, ¿ Automatismo ?...
#
# Necesita que se pase como parametro un fichero con el listado de los nombres para los igroups.
# El script genera el iqn: iqn.AAAA-MM.com.broadcom.${NAME}

function usage() {
  cat << __EOF__
Uso: $1 <file with names>
__EOF__
}

[ $# < 1 ] && usage $0 && exit 1
[ ! -f "$1" ] && echo "file $1 not found or not correct" && exit 2 

set -e
for NAME in $(cat $1)
do
  IQN="iqn.$(date +%Y-%m).com.broadcom.${NAME}"
  echo "igroup create -i -t linux ${NAME}"
  echo "igroup add ${NAME} ${IQN}"
  echo "lun map /vol/vol_abada_iaas_01_c1/${NAME}_01 ${NAME}"
done

