#!/usr/bin/env bash
declare -rx PS4='+ $(basename ${BASH_SOURCE[0]:-${FUNCNAME[0]:-"Unknown"}})[${LINENO}]${id}: '
#
# Good script example that follows all RRFS norms.
#

source /etc/profile

export PDY=20250101
export CYC=12

echo "${PDY} ${CYC}"
