#!/usr/bin/env bash
declare -rx PS4='+ $(basename ${BASH_SOURCE[0]:-${FUNCNAME[0]:-"Unknown"}})[${LINENO}]${id}: '
set -x
date
#
# Good j-job example that follows all RRFS norms.
#

source /etc/profile

if [[ -s /tmp/input.dat ]]; then
  echo "file exists and is not empty"
fi

if [[ "${FOO}" == "bar" ]]; then
  echo "match"
fi

export WALLTIME_UPP=${WALLTIME_UPP:-"00:50:00"}

echo "${HOME}" "${USER}"

if (( count == 5 )); then
  echo "five"
fi

if [[ -z "${cycles}" ]]; then
  echo "empty"
fi

HOSTNAME=$(hostname)

DO_JEDI=true

if [[ "${DO_JEDI^^}" == "TRUE" ]]; then
  echo "jedi on"
fi
