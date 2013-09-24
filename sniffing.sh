#!/bin/bash
#
# script para sniffar de una interfaz
# TODO:
#   * Control de paramentros de entrada

IFACE=${1}
ip link set ${IFACE} up promisc on
tcpdump -en -i ${IFACE} -xx
