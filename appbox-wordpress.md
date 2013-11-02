Appbox Wordpress
================

```
curl -LO http://wordpress.org/latest.tar.gz
tar zxvf latest.tar.gz

mv wordpress /vagrant/www
```

```
server {
  listen unix:/var/run/nginx-apps-wordpress.sock;
        root /vagrant/www;
        index index.php index.html index.htm;

        location / {
                try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
                fastcgi_split_path_info ^(index\.php)(/.+)$;
                fastcgi_pass unix:/var/run/php5-fpm.sock;
    # proxy_redirect off;
    # proxy_set_header Host $host:$server_port;
    # proxy_set_header X-Real-IP $remote_addr;
    # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                fastcgi_index index.php;
                fastcgi_intercept_errors off;
                fastcgi_read_timeout 300;
                include fastcgi_params;
        }
}
```

```
location ~ ^/wordpress(/|$) {
  rewrite ^/wordpress(/|$)(.*) /wordpress/$2 break;
  proxy_pass http://unix:/var/run/nginx-apps-wordpress.sock;
  proxy_redirect off;
  proxy_set_header Host $host:$server_port;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```
