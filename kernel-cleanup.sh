#!/bin/bash
# Run this script without any param for a dry run
# Run the script with root and with exec param for removing old kernels after checking
# the list printed in the dry run

IN_USE=$(uname -a | awk '{ print $3 }')

OLD_KERNELS=$(
    dpkg --list |
        grep -v "${IN_USE%%-generic}" |
        grep -Ei 'linux-image|linux-headers|linux-modules' |
        awk '{ print $2 }' |
        grep -E "^linux-(headers|modules|image)-[0-9].*"
)

if [ "$1" == "exec" ]; then
    for PACKAGE in $OLD_KERNELS; do
        echo "removing $PACKAGE"
        rm /lib/modules/$PACKAGE/kernel/drivers/net/wireless/ath/ath.ko.xz &>/dev/null
        yes | apt purge "$PACKAGE"
        yes | apt install linux-image-generic
    done
else
  echo "Current kernel: $IN_USE"
  echo "To be removed:  $OLD_KERNELS" | tr '\n' ' '
  echo
fi
