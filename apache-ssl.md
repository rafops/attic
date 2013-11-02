Apache SSL
==========

```
$domain=mydomain.com
openssl genrsa -des3 -out $domain.key 2048
openssl rsa -in $domain.key -out $domain.key.insecure
mv $domain.key $domain.key.secure
mv $domain.key.insecure $domain.key
openssl req -new -key $domain.key -out $domain.csr
openssl x509 -req -days 365 -in $domain.csr -signkey $domain.key -out $domain.crt
sudo cp $domain.crt /etc/ssl/certs
sudo cp $domain.key /etc/ssl/private
```

```
<VirtualHost *:443>
  SSLEngine on
  SSLCertificateFile    /etc/ssl/certs/mydomain.com.crt
  SSLCertificateKeyFile /etc/ssl/private/mydomain.com.key
</VirtualHost>
```

https://help.ubuntu.com/10.04/serverguide/certificates-and-security.html

```
domain=xpto.com.br
openssl genrsa -des3 -out $domain.key 2048
openssl req -new -key $domain.key -out $domain.csr
```

```
Common Name: www.$domain
Organization: BLABLA BLA LTDA ME 
Organization Unit: T.I
City or Locality: Sao Paulo
State or Province: Sao Paulo
Country: BR
```
