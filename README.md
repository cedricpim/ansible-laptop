# ansible-laptop

### First time setup

```
$ pacman -Sy git ansible-base make
$ git clone https://github.com/cedricpim/ansible-laptop
$ cd ansible-laptop
$ make install
```

Then, once everything is setup.

```
$ arch-chroot /mnt
$ cd /root/ansible-laptop
$ make install
```

### Internet setup

#### IWD (recommended)

If using `iwd`, then you should do the following (make sure
wpa_supplicant is not running):

```
$ ip link set NETWORK_INTERFACE up
$ iwctl
[iwd]# device list
[iwd]# station device scan
[iwd]# station device get-networks
[iwd]# station device connect SSID (and put passphrase if requested)
[iwd]# quit
```

#### WPA Supplication

If using `wpa_supplicant`, then you can get internet connection by
running the following:

```
$ ip link set NETWORK_INTERFACE up
$ wpa_supplicant -B -i NETWORK_INTERFACE -c <(wpa_passphrase NETWORK_NAME NETWORK_PASSPHRASE)
$ dhcpcd NETWORK_INTERFACE
```

