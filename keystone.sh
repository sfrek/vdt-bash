#!/bin/bash

# We need:
# export OS_SERVICE_TOKEN=TheAdminToken
# export OS_SERVICE_ENDPOINT=http://controller:35357/v2.0
function debug(){
	echo -e "\033[01;37m[debug]\033[00m ${@}"
}

function get_id (){
    echo `$@ | awk '/ id / { print $4 }'`
}

function create_tenant(){
	local TENANT=${1};shift
	local DESC="${@}"
	keystone tenant-create --name=${TENANT} --description="${DESC}"
}

function create_role(){
	local ROLE=${1}
	keystone role-create --name=${ROLE}
}

function create_user(){
	local USER=${1}
	local PASS=${2:-$(openssl rand -hex 8)}
	local MAIL=${3:-${USER}@$(hostname -f)}
	keystone user-create --name=${USER} --pass=${PASS} --email=${MAIL}
}

function create_admin(){
	local ADMIN_PASS=${1}
	# keystone tenant-create --name=admin --description="Admin Tenant"
	# keystone tenant-create --name=service --description="Service Tenant"
	# keystone role-create --name=admin
	# keystone user-create --name=admin --pass=${ADMIN_PASS} --email=root@localhost
	create_tenant admin "Admin Tenant"
	create_role admin
	create_user admin ${PASS} root@localhost
	keystone user-role-add --user=admin --tenant=admin --role=admin
}


# admin #
create_admin Labo.!2013
create_tenant service Service Tenant

# FIXME:
# Make yml or json with initial keystone definitions...

# identity service and end point
END_POINT_ID=$(get_id keystone service-create --name=keystone --type=identity --description="Keystone Identity Service")
keystone endpoint-create --service-id=${END_POINT_ID} \
	--publicurl=http://controller:5000/v2.0 \
	--internalurl=http://controller:5000/v2.0 \
	--adminurl=http://controller:35357/v2.0
