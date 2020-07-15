# ansible-laptop

### Internet setup

If using `wpa_supplicant`, then you can get internet connection by
running the following:

```
$ ip link set NETWORK_INTERFACE up
$ wpa_supplicant -B -i NETWORK_INTERFACE -c <(wpa_passphrase NETWORK_NAME NETWORK_PASSPHRASE)
$ dhcpcd NETWORK_INTERFACE
```

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
