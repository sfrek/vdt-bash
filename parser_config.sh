#!/bin/bash
#
# function to parse yaml config file
#
config_file=../configs/hosts.yml
function get_network()
{
  awk "/$1/ {print \$NF}" ${config_file}
  # grep $1 ${config_file} | cut -d' ' -f3
}

get_network mgmtpro
