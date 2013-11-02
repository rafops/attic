Appbox
======

Appbox is a secure application server made for easy management.

Setup
-----

### Vagrant

```
mkdir -p appbox
cd appbox
vagrant box add precise64 http://files.vagrantup.com/precise64.box
vagrant init precise64
```

#### Vagrantfile

```ruby
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "512"]
  end
end
```

```
vagrant up
```

### Server setup

```
vagrant ssh
```

#### Timezone

Configure timezone for 'America/Sao_Paulo'

```
sudo dpkg-reconfigure tzdata
```

#### System upgrade

```
sudo apt-get update
sudo apt-get upgrade
```

Note: Install boot loader at /dev/sda

#### Removing portmap

```
sudo service portmap stop
sudo apt-get --purge remove rpcbind nfs-common portmap
sudo apt-get autoremove
```

#### Guest additions

Updating VirtualBox guest additions:

```
cd /vagrant
wget http://download.virtualbox.org/virtualbox/4.3.2/VBoxGuestAdditions_4.3.2.iso
sudo mount -r VBoxGuestAdditions_4.3.2.iso -o loop /mnt

sudo apt-get install build-essential linux-headers-$(uname -r)

cd /mnt
sudo sh VBoxLinuxAdditions.run --nox11
```

### PHP

```
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php5
sudo apt-get update
sudo apt-get install php5-cli php5-gd php5-curl php5-xmlrpc php5-xsl php5-json \
                     php5-mcrypt php5-imagick php5-fpm php5-mysqlnd \
                     php5-readline php5-imap php5-intl php5-tidy
```

```
sudo vi /etc/php5/fpm/php.ini
```

```ini
cgi.fix_pathinfo=0
display_errors = On
display_startup_errors = On
error_reporting = E_ALL
html_errors = On
log_errors = On
short_open_tag = Off
track_errors = On
default_charset = "UTF-8"
date.timezone = America/Sao_Paulo
iconv.input_encoding = UTF-8
iconv.internal_encoding = UTF-8
iconv.output_encoding = UTF-8
```

#### Tunning

```
mem_total_kb=`cat /proc/meminfo | grep MemTotal | sed s/"MemTotal:\s\+\([0-9]\+\).*$"/\\\1/`
half_mem_mb=`expr $mem_total_kb \/ 2048`
max_children=`expr $half_mem_mb \/ 24`
```

```
sudo sed -i -e s/"^pm.max_children\ =\ [0-9]\+$"/"pm.max_children = $max_children"/ /etc/php5/fpm/pool.d/www.conf
```

```
sudo sed -i -e s/"^;pm.max_requests\ =\ \([0-9]\+\)$"/"pm.max_requests = \\1"/ /etc/php5/fpm/pool.d/www.conf
```

```
sudo service php5-fpm restart
```

### Nginx

```
sudo add-apt-repository ppa:nginx/stable
sudo apt-get update
sudo apt-get install nginx
```

#### Tunning

```
processors=`cat /proc/cpuinfo | grep processor | wc -l`
sudo sed -i -e s/"^worker_processes [0-9]\+;"/"worker_processes $processors;"/ /etc/nginx/nginx.conf
```

#### AppBox

Running nginx on a VirtualBox VM you will need to disable sendfile:

```
sudo vi /etc/nginx/nginx.conf
```

```
http {
        sendfile off;
}
```

```
sudo vi /etc/nginx/sites-available/apps
```

```
server {
  listen 8080 default_server;
  listen [::]:8080 default_server ipv6only=on;
  server_name localhost;
  root /vagrant/www;

  location / {
    return 404;
  }

  location ~ /\.ht {
    return 404;
  }

  location = /favicon.ico {
    log_not_found off;
    access_log off;
  }

  location = /robots.txt {
    log_not_found off;
    access_log off;
  }

  location ~* \.(gif|jpeg|jpg|png|ico)$ {
    expires max;
  }

  include /etc/nginx/apps/*-proxy.conf;
}

include /etc/nginx/apps/*-server.conf;
```

Apps examples:

```
sudo mkdir -p /etc/nginx/apps
```

```
sudo vi /etc/nginx/apps/generic-proxy.conf
```

```
location ~ ^/generic(/|$) {
  rewrite ^/generic(/|$)(.*) /$2 break;
  proxy_pass http://unix:/var/run/nginx-apps-generic.sock;
}
```

```
sudo vi /etc/nginx/apps/generic-server.conf
```

```
server {
  listen unix:/var/run/nginx-apps-generic.sock;
  root /vagrant/www/generic;
  index index.php index.html index.htm;

  location / {
    try_files $uri $uri/ =404;
  }

  location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    fastcgi_intercept_errors off;
    fastcgi_read_timeout 300;
    include fastcgi_params;
  }
}
```

```
sudo vi /etc/nginx/apps/zf2-proxy.conf
```

```
location ~ ^/zf2(/|$) {
  rewrite ^/zf2(/|$)(.*) /$2 break;
  proxy_pass http://unix:/var/run/nginx-apps-zf2.sock;
}
```

```
sudo vi /etc/nginx/apps/zf2-server.conf
```

```
server {
  listen unix:/var/run/nginx-apps-zf2.sock;
  root /vagrant/www/zf2/public;
  index index.php index.html index.htm;

  server_name _;

  location / {
    try_files $uri $uri/ /index.php?$query_string;
  }

  location ~* index\.php$ {
    fastcgi_split_path_info ^(index\.php)(/.+)$;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    fastcgi_intercept_errors off;
    fastcgi_read_timeout 300;
    include fastcgi_params;
  }
}
```

Activating:

```
cd /etc/nginx/sites-enabled
sudo rm default
sudo ln -s ../sites-available/apps
sudo service nginx restart
```

### MySQL

```
sudo apt-get install mysql-server
```

#### Create, Grant, Migrate

```
mysql -uroot -e "GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON generic.* TO generic@localhost"
mysql -uroot -e "GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON zf2.* TO zf2@localhost"
...
```
mysql -uroot -e "GRANT CREATE, ALTER, SELECT, INSERT, UPDATE, DELETE ON wordpress.* TO wordpress@localhost IDENTIFIED BY 'wordpress'"
