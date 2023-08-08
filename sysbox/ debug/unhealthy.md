un-healty
```
root@ip-10-0-50-152:/etc/cni/net.d# journalctl -eu sysbox-installer-helper
Aug 03 13:32:13 ip-10-0-50-152 systemd[1]: Finished Sysbox installer helper service.
Aug 03 13:32:13 ip-10-0-50-152 systemd[1]: sysbox-installer-helper.service: Succeeded.
Aug 03 13:32:13 ip-10-0-50-152 systemd[1]: Stopped Sysbox installer helper service.
Aug 03 13:37:21 ip-10-0-50-152 systemd[1]: Starting Sysbox installer helper service...
Aug 03 13:37:21 ip-10-0-50-152 sh[80789]: Reading package lists...
Aug 03 13:37:21 ip-10-0-50-152 sh[80789]: Building dependency tree...
Aug 03 13:37:21 ip-10-0-50-152 sh[80789]: Reading state information...
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]: ca-certificates is already the newest version (20230311ubuntu0.20.04.1).
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]: The following packages were automatically installed and are no longer required:
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]:   cpp cpp-9 dctrl-tools fakeroot g++ g++-9 gcc gcc-9 gcc-9-base
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]:   libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]:   libasan5 libatomic1 libc-dev-bin libc6-dev libcc1-0 libcrypt-dev
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]:   libdpkg-perl libfakeroot libfile-fcntllock-perl libgcc-9-dev libisl22
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]:   libitm1 liblsan0 libmpc3 libquadmath0 libstdc++-9-dev libtsan0 libubsan1
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]:   linux-libc-dev manpages-dev
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]: Use 'apt autoremove' to remove them.
Aug 03 13:37:22 ip-10-0-50-152 sh[80789]: 0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Aug 03 13:37:22 ip-10-0-50-152 sh[80794]: Hit:1 http://us-east-2.ec2.archive.ubuntu.com/ubuntu focal InRelease
Aug 03 13:37:22 ip-10-0-50-152 sh[80794]: Hit:2 http://us-east-2.ec2.archive.ubuntu.com/ubuntu focal-updates InRelease
Aug 03 13:37:22 ip-10-0-50-152 sh[80794]: Hit:3 http://us-east-2.ec2.archive.ubuntu.com/ubuntu focal-backports InRelease
Aug 03 13:37:22 ip-10-0-50-152 sh[80794]: Hit:4 http://security.ubuntu.com/ubuntu focal-security InRelease
Aug 03 13:37:22 ip-10-0-50-152 sh[80794]: Hit:5 http://ppa.launchpad.net/cloud-images/eks-01.11.0/ubuntu focal InRelease
Aug 03 13:37:24 ip-10-0-50-152 sh[80794]: Reading package lists...
Aug 03 13:37:24 ip-10-0-50-152 sh[81230]: Reading package lists...
Aug 03 13:37:24 ip-10-0-50-152 sh[81230]: Building dependency tree...
Aug 03 13:37:24 ip-10-0-50-152 sh[81230]: Reading state information...
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]: fuse is already the newest version (2.9.9-3).
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]: iptables is already the newest version (1.8.4-3ubuntu2.1).
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]: rsync is already the newest version (3.1.3-8ubuntu0.5).
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]: The following packages were automatically installed and are no longer required:
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]:   cpp cpp-9 dctrl-tools fakeroot g++ g++-9 gcc gcc-9 gcc-9-base
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]:   libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]:   libasan5 libatomic1 libc-dev-bin libc6-dev libcc1-0 libcrypt-dev
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]:   libdpkg-perl libfakeroot libfile-fcntllock-perl libgcc-9-dev libisl22
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]:   libitm1 liblsan0 libmpc3 libquadmath0 libstdc++-9-dev libtsan0 libubsan1
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]:   linux-libc-dev manpages-dev
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]: Use 'apt autoremove' to remove them.
Aug 03 13:37:25 ip-10-0-50-152 sh[81230]: 0 upgraded, 0 newly installed, 0 to remove and 1 not upgraded.
Aug 03 13:37:25 ip-10-0-50-152 sh[80784]: Skipping shiftfs installation (it's already installed).
Aug 03 13:37:25 ip-10-0-50-152 sh[80784]: Probing kernel modules ...
Aug 03 13:37:25 ip-10-0-50-152 systemd[1]: Finished Sysbox installer helper service.
Aug 03 13:37:25 ip-10-0-50-152 systemd[1]: sysbox-installer-helper.service: Succeeded.
Aug 03 13:37:25 ip-10-0-50-152 systemd[1]: Stopped Sysbox installer helper service.
```

```
Failed to create pod sandbox: rpc error: code = Unknown desc = failed to create pod network sandbox k8s_sysbox-deploy-k8s-27n74_kube-system_1b35b35d-9d58-4644-a1c6-ad18c1e922b0_0(edf24494b4bf0864b178b83e1ebca8838316084a3837b8b386fb15fc4b37cb2b): error adding pod kube-system_sysbox-deploy-k8s-27n74 to CNI network "aws-cni": plugin type="aws-cni" name="aws-cni" failed (add): add cmd: Error received from AddNetwork gRPC call: rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing dial tcp 127.0.0.1:50051: connect: connection refused"
```
