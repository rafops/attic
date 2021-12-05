# Let's Encrypt

## New Certificate

Install certbot:

	sudo snap install --classic certbot

Generate wildcard certificate:

	sudo certbot certonly --manual --preferred-challenges=dns --email example@example.com --agree-tos -d *.example.com

Create the TXT record and press Enter to continue certbot validation.

Certificates will be stored in `/etc/letsencrypt/live/example.com/`.

## Lighttpd

```
  sudo cat /etc/letsencrypt/live/example.com/privkey.pem \
           /etc/letsencrypt/live/example.com/cert.pem | \
  sudo tee /etc/letsencrypt/live/example.com/combined.pem
```

```
sudo chown www-data -R /etc/letsencrypt/live
```

```
$HTTP["host"] == "example.com" {
  setenv.add-environment = ("fqdn" => "true")

  $SERVER["socket"] == ":443" {
    ssl.engine = "enable"
    ssl.pemfile = "/etc/letsencrypt/live/example.com/combined.pem"
    ssl.ca-file =  "/etc/letsencrypt/live/example.com/fullchain.pem"
    ssl.honor-cipher-order = "enable"
    ssl.cipher-list = "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH"
    ssl.use-sslv2 = "disable"
    ssl.use-sslv3 = "disable"       
  }

  $HTTP["scheme"] == "http" {
    $HTTP["host"] =~ ".*" {
      url.redirect = (".*" => "https://%0$0")
    }
  }
}
```

### uHTTPd

Convert the private key and the certificate from the ASCII-armored PEM format to the binary DER format:

```
openssl rsa -in privkey.pem -outform DER -out uhttpd.key
openssl x509 -in fullchain.pem -outform DER -out uhttpd.crt
```

Edit `/etc/config/uhttpd`:

```
config uhttpd 'example.com'
    list listen_http '0.0.0.0:80'
    list listen_https '0.0.0.0:443'
    option redirect_https '1'
    option home '/www'
    option rfc1918_filter '0'
    option cert '/etc/uhttpd.crt'
    option key '/etc/uhttpd.key'
```
