# APUWifi
APU Debian 11 Wifi Driver Patch

adjust in wifi-patch.sh the base path. currently configured to expect the scripts to be in /home/admin/APUWifi.

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
remove_old-kernels.sh will remove the old stuff saving space.

Also... must use...

https://github.com/singe/wifi-frequency-hacker

:)
