```
gem install puma -- --with-cppflags=-I/usr/local/opt/openssl/include --with-ldflags=-L/usr/local/opt/openssl/lib
```

openssl genrsa -des3 -out server.orig.key 2048
openssl rsa -in server.orig.key -out server.key
openssl req -new -key server.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

puma -b 'ssl://127.0.0.1:3000?key=server.key&cert=server.crt'

References:

https://gist.github.com/tadast/9932075
http://stackoverflow.com/questions/27465544/cannot-build-puma-gem-on-os-x-yosemite
