healthy
```
root@ip-10-0-40-22:/etc/cni/net.d# journalctl -eu sysbox-installer-helper
Aug 03 12:21:25 ip-10-0-40-22 sh[19186]: debconf: falling back to frontend: Teletype
Aug 03 12:21:25 ip-10-0-40-22 sh[19216]: EFI variables are not supported on this system
Aug 03 12:21:25 ip-10-0-40-22 sh[19207]: /sys/firmware/efi/efivars not found, aborting.
Aug 03 12:21:25 ip-10-0-40-22 sh[18705]: cleaning build area...
Aug 03 12:21:25 ip-10-0-40-22 sh[18705]: DKMS: build completed.
Aug 03 12:21:25 ip-10-0-40-22 sh[18683]: dkms install -m shiftfs -v k516
Aug 03 12:21:25 ip-10-0-40-22 sh[19297]: shiftfs.ko:
Aug 03 12:21:25 ip-10-0-40-22 sh[19297]: Running module version sanity check.
Aug 03 12:21:25 ip-10-0-40-22 sh[19297]:  - Original module
Aug 03 12:21:25 ip-10-0-40-22 sh[19297]:    - No original module exists within this kernel
Aug 03 12:21:25 ip-10-0-40-22 sh[19297]:  - Installation
Aug 03 12:21:25 ip-10-0-40-22 sh[19297]:    - Installing to /lib/modules/5.15.0-1040-aws/updates/dkms/
Aug 03 12:21:27 ip-10-0-40-22 sh[19297]: depmod...
Aug 03 12:21:27 ip-10-0-40-22 sh[19297]: DKMS: install completed.
Aug 03 12:21:27 ip-10-0-40-22 sh[19448]: Reading package lists...
Aug 03 12:21:27 ip-10-0-40-22 sh[19448]: Building dependency tree...
Aug 03 12:21:27 ip-10-0-40-22 sh[19448]: Reading state information...
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: The following packages were automatically installed and are no longer required:
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]:   cpp cpp-9 dctrl-tools fakeroot g++ g++-9 gcc gcc-9 gcc-9-base
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]:   libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]:   libasan5 libatomic1 libc-dev-bin libc6-dev libcc1-0 libcrypt-dev
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]:   libdpkg-perl libfakeroot libfile-fcntllock-perl libgcc-9-dev libisl22
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]:   libitm1 liblsan0 libmpc3 libquadmath0 libstdc++-9-dev libtsan0 libubsan1
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]:   linux-libc-dev manpages-dev
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: Use 'apt autoremove' to remove them.
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: The following packages will be REMOVED:
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]:   build-essential* dkms* dpkg-dev* make*
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: 0 upgraded, 0 newly installed, 4 to remove and 1 not upgraded.
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: After this operation, 2835 kB disk space will be freed.
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: [614B blob data]
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: Removing dkms (2.8.1-5ubuntu2) ...
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: Removing build-essential (12.8ubuntu1.1) ...
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: Removing dpkg-dev (1.19.7ubuntu3.2) ...
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: Removing make (4.2.1-1.2) ...
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: [614B blob data]
Aug 03 12:21:28 ip-10-0-40-22 sh[19448]: Purging configuration files for dpkg-dev (1.19.7ubuntu3.2) ...
Aug 03 12:21:29 ip-10-0-40-22 sh[19448]: Purging configuration files for dkms (2.8.1-5ubuntu2) ...
Aug 03 12:21:29 ip-10-0-40-22 sh[19448]: dpkg: warning: while removing dkms, directory '/var/lib/dkms' not empty so not removed
Aug 03 12:21:30 ip-10-0-40-22 sh[14346]: Shiftfs installation done.
Aug 03 12:21:30 ip-10-0-40-22 sh[14346]: Probing kernel modules ...
Aug 03 12:21:30 ip-10-0-40-22 systemd[1]: Finished Sysbox installer helper service.
Aug 03 12:21:30 ip-10-0-40-22 systemd[1]: sysbox-installer-helper.service: Succeeded.
Aug 03 12:21:30 ip-10-0-40-22 systemd[1]: Stopped Sysbox installer helper service.
```