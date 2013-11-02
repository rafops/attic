Three.js
========

Install [node.js](http://nodejs.org) from source:

```
curl -O http://nodejs.org/dist/v0.10.26/node-v0.10.26-linux-x64.tar.gz
tar zxvf node-v0.10.26-linux-x64.tar.gz
cd node-v0.10.26
./configure
make
sudo make install
```

or using Mac OS X Installer:

```
http://nodejs.org/dist/v0.10.26/node-v0.10.26.pkg
```

Install [Yeoman](http://yeoman.io):

```
sudo npm install -g yo
```

Install Three.js generator:

```
sudo npm install -g generator-threejs
```

Install git:

```
http://git-scm.com/book/en/Getting-Started-Installing-Git
```

Scaffold application:

```
yo threejs:app
```

Install dependencies:

```
npm install
bower install
```

Start server:

```
grunt serve
```
