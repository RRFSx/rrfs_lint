#!/usr/bin/env bash
# This file demonstrates the suppression mechanism.

# Suppress a specific rule on a line
. /etc/profile  # rrfslint: disable=RRFS001

# Suppress the next line
# rrfslint: disable-next-line=RRFS002
if [ -d /tmp ]; then
  echo "this bracket won't trigger"
fi

export my_lowercase="ok"  # rrfslint: disable=RRFS007
