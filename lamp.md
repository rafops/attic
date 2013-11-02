LAMP
====

Create a Vagrant box instance
-----------------------------

```
vagrant box add precise32 http://files.vagrantup.com/precise32.box
vagrant init precise32
vagrant up
```


Update guest additions
----------------------

```
vagrant ssh
wget http://download.virtualbox.org/virtualbox/4.3.2/VBoxGuestAdditions_4.3.2.iso
sudo mount -r VBoxGuestAdditions_4.3.2.iso -o loop /mnt

sudo apt-get install build-essential linux-headers-$(uname -r)

cd /mnt
sudo sh VBoxLinuxAdditions.run --nox11

exit
vagrant reload
```


Download Chef recipes
---------------------

```
mkdir -p cookbooks
cd cookbooks
echo "apt apache2 php mysql" | xargs -n 1 knife cookbook site download
echo *.tar.gz | xargs -n 1 tar xzf
```


Vagrantfile
-----------

```ruby
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "apt"
    chef.add_recipe "mysql::server"
    chef.add_recipe "php"
    chef.add_recipe "php::module_mysql"
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "apache2::mod_rewrite"
    chef.json = {
      "mysql" => {
        "server_root_password" => "vagrant",
        "server_repl_password" => "vagrant",
        "server_debian_password" => "vagrant"
      }
  end
end
```


Provisioning
------------

```
vagrant reload
vagrant provision
```
