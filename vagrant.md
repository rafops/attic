Vagrant
=======

Download and install
--------------------

Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

Download and install [Vagrant](http://downloads.vagrantup.com).

Download and install base box:

```
vagrant box add precise32 http://files.vagrantup.com/precise32.box
vagrant init precise32
vagrant up
```


Vagrantfile basic configuration
-------------------------------

```ruby
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
end
```


Updating guest additions to match VirtualBox version
----------------------------------------------------

```
vagrant ssh
wget http://download.virtualbox.org/virtualbox/4.3.8/VBoxGuestAdditions_4.3.8.iso
sudo mount -r VBoxGuestAdditions_4.3.8.iso -o loop /mnt

sudo apt-get install build-essential linux-headers-$(uname -r)

cd /mnt
sudo sh VBoxLinuxAdditions.run --nox11

exit
vagrant reload
```


Recompiling guest additions to match kernel version
---------------------------------------------------

```
vagrant ssh

sudo apt-get install build-essential linux-headers-$(uname -r)
sudo /etc/init.d/vboxadd setup

exit 
vagrant reload
```


Packaging a box
---------------

```
cp Vagrantfile Vagrantfile.pkg
vagrant package --vagrantfile Vagrantfile.pkg
```

Multi machine config
--------------------

```
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "webserver" do |web|
    web.vm.box = "precise64"
    web.vm.network :forwarded_port, guest: 80, host: 8080
    web.vm.network :private_network, ip: "192.168.33.10"
    web.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
  end

  config.vm.define "database" do |db|
    db.vm.box = "precise64"
    db.vm.network :private_network, ip: "192.168.33.20"
    db.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
    end
  end
end
```
