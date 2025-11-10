# ansible-laptop

### First time setup

```
$ pacman -Sy git ansible-base make
$ git clone https://github.com/cedricpim/ansible-laptop
$ cd ansible-laptop
$ ansible-galaxy collection install ansible.posix
$ ansible-galaxy collection install community.general
$ make install
```

Then, once everything is setup.

```
$ arch-chroot /mnt
$ cd /root/ansible-laptop
$ make install
```

Reboot and then login to root and run:

```
$ yay -Sy --mflags '--skippgpcheck' mullvad-vpn
$ SLOW_PACKAGES=1 make arch
```

Reboot, move to command line from greeter, login to user and run:

```
$ make dotfiles
```

### Reset drive

```
$ lvchange -an /dev/Vol/{home,data,tmp,root,...}
$ lvremove /dev/Vol/{home,data,tmp,root,...}
$ vgremove Vol
$ pvremove /dev/sda
```

After, use parted to remove any partitions.

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

#### NetworkManager

Once `NetworkManager` is running, it overrides all other network related
applications, so it must be used as:

```
$ nmcli device wifi list
$ nmcli device wifi connect "SSID" password "PASSWORD"
```

#### WPA Supplication

If using `wpa_supplicant`, then you can get internet connection by
running the following:

```
$ ip link set NETWORK_INTERFACE up
$ wpa_supplicant -B -i NETWORK_INTERFACE -c <(wpa_passphrase NETWORK_NAME NETWORK_PASSPHRASE)
$ dhcpcd NETWORK_INTERFACE
```

### Boot from Live

Use `lsblk` and `blkid` to find the right partition.

```
$ mkdir /mnt/temp
$ cryptsetup luksOpen partition arch
$ vgscan
$ vgchange -ay (result from vgscan)
$ lvs
$ mount /dev/(result from vgscan)/(result from lvs) /mnt/temp
$ arch-root /mnt/temp
```
