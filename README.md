# APUWifi

Automatic atheros wifi driver patch for debian.

Developed for the PC Engines APU boards (with wifi wlx600 card) but useable for any atheros wifi card on any debian system.


# Install

adjust in wifi-patch.sh the base path. currently configured to expect the scripts to be in /home/admin/APUWifi.

run

```
sudo crontab -e
```

add (fix path if installed in other location)

```
@reboot /home/admin/APUWifi/wifi-patch.sh
@reboot /home/admin/APUWifi/remove_old_kernels.sh exec
```

make sure you have [unattended-upgrades](https://packages.debian.org/unattended-upgrades) installed and kernel upgrades are enabled.

When you reboot with a new kernel: wifi-patch.sh will recompile driver with patch (if someone known how to compile after update and before the reboot let me know) and remove_old-kernels.sh will remove the old stuff saving space.

Also... must use...

https://github.com/singe/wifi-frequency-hacker

:)
