#!/bin/bash

# this should not be hardcoded
base="/home/admin"
DNS='1.1.1.1'
home="$base/APUWifi"
#script="$base/scripts"




cd "$home"
# identifier
linux=$(uname -v | sed 's/#\S\+\( SMP Debian\)\? //' | awk -F ' ' '{ print $1 }' | awk -F '-' '{ print $1 }')
folder='linux-'$linux
# already up to date?
# already compiled?
FILE=$linux/ath.ko.xz
if test -f "$FILE"; then
    update=$(diff $FILE /lib/modules/$(uname -r)/kernel/drivers/net/wireless/ath/ath.ko.xz | wc -l)
    if (($update != 0)); then
        cp  $FILE /lib/modules/$(uname -r)/kernel/drivers/net/wireless/ath/ath.ko.xz
        /usr/sbin/shutdown -r now
    fi
    exit
fi


# dns server is hardcoded... (it runs on the system in vm)

i=0
while (( $(dig @$DNS debian.org | grep ';; connection timed out; no servers could be reached' | wc -l) != 0 )); do
   sleep 15
   ((i++))
   if (( $i == 12 )); then
      echo "Wifi patch update failed could not connect"
      exit
   fi
done

# go for it
apt-get install linux-headers-generic -y

# remove junk in case of crash
sudo rm linux*

# get source
apt-get source linux
# have no idea to NOT get the latest source... simply
mv $(find . -type d -maxdepth 1 | grep linux) $folder

# remove junk
sudo rm linux_*
# backup folder
mkdir $linux
# begin build
cd $folder
make -j5 clean && make -j5 mrproper
cp /usr/src/linux-headers-$(uname -r)/Module.symvers ./
#cp /usr/lib/modules/$(uname -r)/build/Module.symvers ./
cp /boot/config*`uname -r` .config
make -j5 modules_prepare
make -j5 scripts
# backup original
cp drivers/net/wireless/ath/regd.c ../$linux/regd.c
# use older version if patch fails  (so what ;)
cp ../regd.c.patch drivers/net/wireless/ath/regd.c
# create patch
diff -u ../$linux/regd.c ../regd.c.org > ../$linux/patch
# apply
patch -R drivers/net/wireless/ath/regd.c ../$linux/patch
# save new patched version
cp drivers/net/wireless/ath/regd.c ../$linux/regd.c.patch
# build patch driver
make -j5 M=drivers/net/wireless/ath
xz drivers/net/wireless/ath/ath.ko
# backup..
cp -f drivers/net/wireless/ath/ath.ko.xz ../$linux/ath.ko.xz
# install
cp -f drivers/net/wireless/ath/ath.ko.xz /lib/modules/$(uname -r)/kernel/drivers/net/wireless/ath/ath.ko.xz
/usr/sbin/depmod -a
cd ..
# update for next itteration
cp $linux/regd.c regd.c.org
cp $linux/regd.c.patch regd.c.patch
rm -rf $folder
#$scripts/remove_old_kernels.sh exec
/usr/sbin/shutdown -r now
