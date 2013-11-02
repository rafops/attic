Ext4 & Mac OS
=============

```
vagrant init precise32
```


### Vagrantfile

```
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.network "private_network", ip: "192.168.50.4"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
end
```


### VMDK

```
disk=disk2

sudo chmod go+rw /dev/$disk
VBoxManage internalcommands createrawvmdk -filename $disk.vmdk -rawdisk /dev/$disk
```

Open VirtualBox

Virtual machine > Settings > Storage > Controller: SATA Controller > Add Hard Disk > Choose existing disk > $disk.vmdk


### Mounting disk

```
vagrant ssh
```

```
sudo mkdir /mnt/sdb1
sudo mount /dev/sdb1 /mnt/sdb1
```

### Copying files

```
scp -i ~/.vagrant.d/insecure_private_key -r ubuntu@192.168.50.4:/mnt/sdb1 sdb1
```