PHP
===

Configuration
-------------

### Development

```ini
display_errors = On
display_startup_errors = On
error_reporting = E_ALL | E_STRICT
html_errors = On
log_errors = On
short_open_tag = Off
track_errors = On
default_charset = UTF-8
date.timezone = UTC
iconv.input_encoding = UTF-8
iconv.internal_encoding = UTF-8
iconv.output_encoding = UTF-8
```

### Production

```ini
display_errors = Off
display_startup_errors = Off
error_reporting = E_ALL & ~E_DEPRECATED
html_errors = Off
track_errors = Off
```


Extensions
----------

* apc
* curl
* gd
* mbstring
* memcached
* oci8
* pdo
* pdo_mysql

* [Core Extensions](http://www.php.net/manual/en/extensions.membership.php)


Web Server
----------

* Apache MPM worker
* Apache mod_fastcgi
* FastCGI Process Manager (PHP-FPM)

### PHP-FPM

```
listen = /var/run/php5-fpm.socket
```

http://php-fpm.org/wiki/Configuration_File

### Apache

```
AddDefaultCharset UTF-8
```

```
AddHandler php5-fcgi .php
Action php5-fcgi /php5-fcgi
Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.socket -pass-header Authorization
```

```
a2enmod actions fastcgi alias
```

* [Apache MPM Worker](http://httpd.apache.org/docs/2.2/mod/worker.html)


Multibyte strings
-----------------

* [Working with Multibyte Strings](http://www.sitepoint.com/working-with-multibyte-strings)


Dependency management
---------------------

* [Composer](https://getcomposer.org)


Cache
-----

* [Varnish or Nginx?](https://speakerdeck.com/thijsferyn/varnish-or-nginx-symfony-live)
* [APC](http://www.php.net/manual/en/apc.configuration.php)
* [Varnish](https://www.varnish-cache.org)
* [Edge Side Include](https://github.com/SocalNick/ScnEsiWidget)


Session
-------

* [Memcached](http://php.net/manual/en/memcached.sessions.php)
* [Zend\Cache\Storage\Adapter\Memcached](http://framework.zend.com/manual/2.2/en/modules/zend.cache.storage.adapter.html#the-memcached-adapter)

Database
--------

### Oracle

* [Getting Started with PHP Zend Framework 2 for Oracle DB](https://blogs.oracle.com/opal/entry/getting_started_with_php_zend)
* [The Underground PHP and Oracle Manual](http://www.oracle.com/technetwork/topics/php/201212-ug-php-oracle-1884760.pdf)
* [PHP Manual OCI8 Connection](http://php.net/manual/en/oci8.connection.php)
* [PHP and Oracle](https://blogs.oracle.com/opal)
* [PHP Scalability and
High Availability](http://www.oracle.com/technetwork/topics/php/php-scalability-ha-twp-128842.pdf)

### Object Relational Mapper

* [Doctrine ORM](http://www.doctrine-project.org/projects/orm.html)

### Database Abstraction Layer

* [Doctrine DBAL](http://www.doctrine-project.org/projects/dbal.html)


Logging
-------

* [Zend\Log\Writer\Syslog](http://framework.zend.com/apidoc/2.1/classes/Zend.Log.Writer.Syslog.html)


Testing
-------

* [PHPUnit](https://github.com/sebastianbergmann/phpunit)
* [phpspec](http://www.phpspec.net)
* [Behat](http://behat.org)
* [Codeception](http://codeception.com)


Code quality
------------

* [PHPLOC](https://github.com/sebastianbergmann/phploc)
* [PHPCPD](https://github.com/sebastianbergmann/phpcpd)
* [PHP CodeSniffer](http://pear.php.net/package/PHP_CodeSniffer)
* [PHP Coding Standards Fixer](http://cs.sensiolabs.org)
* [PHP Depend](http://pdepend.org)
* [PHPMD](http://phpmd.org)


Debug
-----

### Xdebug + QCacheGrind

```
sudo apt-get install php5-xdebug
vim /etc/php5/conf.d/xdebug.ini
```

```ini
zend_extension=/usr/lib/php5/20090626/xdebug.so
xdebug.profiler_enable = 1
xdebug.profiler_output_dir = /vagrant/xdebug/
```

```
sudo /etc/init.d/php5-fpm restart
```

```
brew install qcachegrind
```

* [XHProf](https://github.com/facebook/xhprof)
* [xDebug](http://xdebug.org)


Best practices
--------------

* [PSR-0 Autoloader](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md)
* [PSR-1 Basic coding standard](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-1-basic-coding-standard.md)
* [PSR-2 Coding style guide](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md)
* [PSR-3 Logger interface](https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-3-logger-interface.md)
* [PHP: The Right Way](http://www.phptherightway.com)
