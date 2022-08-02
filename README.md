# APUWifi
APU Debian 11 Wifi Driver Patch

(script expected to be in /home/admin/APUWifi)

run

```
sudo crontab -e
```

add (fix path if downloaded in other location)

```
@reboot /home/admin/APUWifi/wifi-patch.sh
@reboot /home/admin/APUWifi/remove_old_kernels.sh exec
```

wifi-patch.sh will recompile driver after reboot... (if someone known how to compile after update and before the reboot let me know)
remove_old-kernels.sh will remove and old stuff...

note... harcoded.... change inside file... "this should not be hardcoded" /home/admin/APUWifi/wifi-patch.sh


