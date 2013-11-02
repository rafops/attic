GTP/HFS+Ext4 encrypted
======================

```
sudo gdisk -l /dev/sdb
sudo cryptsetup luksOpen /dev/sdb4 sdb4
sudo mount /dev/mapper/sdb4 /mnt/sdb4
```
