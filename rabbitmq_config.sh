#!/bin/bash

function get_pass(){
	return $(openssl rand -hex 16)
}

function create_admin(){
	local USER=${1}
	local PASS=${2}
	cat << __CONFIG__ >> ~/.temporal_pass
- rabbitmq:
	user: ${USER}
	password: ${PASS}
__CONFIG__
	rabbitmqctl add_user ${USER} ${PASS}
	rabbitmqctl set_permissions ${USER} ".*" ".*" ".*"
	rabbitmqctl set_user_tags ${USER} administrator
	rabbitmqctl list_users
}

[[ $# < 1 ]] && echo "falta user" && exit 1

# create_admin $1 $(get_pass)
create_admin openstack openstack
rabbitmqctl delete_user guest
rabbitmq-plugins enable rabbitmq_management
