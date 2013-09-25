#!/bin/bash
#
# script for start/stop openstack services
#

function action_over_service(){
	local ACTION=${1}
	local SERVICE=${2}
	for DAEMON in /etc/init.d/${SERVICE}*;do
		service ${DAEMON##*/} ${ACTION}
	done
}

[ $# -lt 2 ] && echo "Params Error" && exit 1
[ "$2" == "ALL" ] && SERVICES="quantum cinder glance keystone nova" || SERVICES=$2

for SERVICE in ${SERVICES};do
	echo -e "\033[01;35m${1}ing ${SERVICE}\033[00m"
	action_over_service ${1} ${SERVICE}
done

