# ansible-laptop

### Internet setup

If you are using `wpa_supplicant`, then you can get internet connection by
running the following:

```
$ ip link set NETWORK_INTERFACE up
$ wpa_supplicant -B -i NETWORK_INTERFACE -c <(wpa_passphrase NETWORK_NAME NETWORK_PASSPHRASE)
$ dhcpcd NETWORK_INTERFACE
```

If you are using `connmanctl`, then you should do the following (make sure
wpa_supplicant is not running):

```
$ connmanctl enable wifi
$ connmanctl
connmanctl> scan wifi
connmanctl> services
connmanctl> agent on
connmanctl> connect WIFI_ID (and put passphrase if requested)
connmanctl> quit
```
