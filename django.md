Django
======

Development server
------------------

### Vagrant box with CentOS 6.4

```
vagrant box add centos64 http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box
vagrant init centos64
```

### Chef recipes

```
mkdir -p cookbooks
cd cookbooks
echo "apt build-essential mysql apache2 python" | xargs -n 1 knife cookbook site download
echo *.tar.gz | xargs -n 1 tar xzf
```

### Vagrantfile

```ruby
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos64"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "mysql::server"
    chef.add_recipe "mysql::client"
    chef.add_recipe "apache2"
    chef.add_recipe "python"
    chef.add_recipe "apache2::mod_wsgi"
    chef.add_recipe "python::pip"
    chef.json = {
      "mysql" => {
        "server_root_password" => "vagrant",
        "server_repl_password" => "vagrant",
        "server_debian_password" => "vagrant"
      }
      ## "python" => {
      ##   "version" => "2.7.0"
      ## }
    }
  end
end
```
