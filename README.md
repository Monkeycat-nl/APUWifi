# APUWifi
APU Debian 11 Wifi Driver Patch

run

sudo crontab -e

add (fix path if downloaded in other location)

@reboot /home/admin/APUWifi/wifi-patch.sh
@reboot /home/admin/APUWifi/remove_old_kernels.sh exec

harcoded.... change inside file... "this should not be hardcoded" /home/admin/APUWifi/wifi-patch.sh


