#!/bin/bash
#
# Script para levantar una interfaz vlan
# TODO:
#   * Control de parametros de entrada
#   * ID vlan por linea de comandos
#   * IP y CDIR por linea de comandos
#   * usar getops para que la llamada sea algo como:
#     vlan.sh -I <IP> -C <CDIR> -v <vlan ID> -i <iface> -a {start|stop}

function usage(){
  local SCRIPTNAME=${1}
  cat << __EOF__

Configura vlan.

uso:
  ${SCRIPTNAME} { -i <interfaz> -v <vlan ID> -I <cdir ip> -a {start|stop} } | { -h }

explicacion:
  -i  Interfaz etherne que se quiere levantar como vlan.
  -v  Id de la vlan
  -I  ip para la interfaz en formato cdir, ejemplo: 80.65.14.226/28
  -a  acción a realizar:
    stop: desactiva la interfaz.
    start: activa la interfaz.
  -h  muestra esta ayuda

importante:
  Con la "acción" stop el parametro de la interfaz de red ( -i ) es obligatorio.
  Con la "acción" start todos los parametros son obligatorios.
  
__EOF__
}

function vlan_start(){
	local IFACE=${1}
  local VLAN=${2}
  local IP_CDIR=${3}
	ip link add link ${IFACE} name ${IFACE}.${VLAN} type vlan id ${VLAN}
	ip addr add ${IP_CDIR} dev ${IFACE}.${VLAN}
	ip link set ${IFACE} up
	ip link set ${IFACE}.${VLAN} up
}

function vlan_stop(){
	local IFACE=${1}
  local VLAN=${2}
	ip link set ${IFACE}.${VLAN} down
	ip addr flush ${IFACE}.${VLAN}
	ip link delete dev ${IFACE}.${VLAN} type vlan
	ip link set ${IFACE} down
	ip addr flush ${IFACE}
}

# __main__
SCRIPTNAME=${0}
ARGUMENTS=${@}

while getopts "i:v:I:a:h" OPTION;do
  case ${OPTION} in
    i)
      IFACE=${OPTARG}
      ;;
    v)
      VLAN=${OPTARG}
      ;;
    I)
      IP_CDIR=${OPTARG}
      ;;
    a)
      ACTION=${OPTARG}
      ;;
    h)
      usage ${SCRIPTNAME}
      exit 0
      ;;
    *)
      echo "Error en alguno de los parámetros:"
      usage ${SCRIPTNAME}
      exit 2
      ;;
  esac
done
      
case ${ACTION} in
	start)
    [ -z "${IFACE}" -o -z "${VLAN}" -o -z "${IP_CDIR}" ] && echo "ERROR: En los parámetros" && exit 3
		vlan_start ${IFACE} ${VLAN} ${IP_CDIR}
		;;
	stop)
    [ -z "${VLAN}" ] && echo "ERROR: falta vlan para" && exit 3
		vlan_stop ${IFACE} ${VLAN}
		;;
  *)
    echo "ERROR: Accion ${ACTION} no reconocida:"
    usage ${SCRIPTNAME}
    exit 4
    ;;
esac

exit 0
