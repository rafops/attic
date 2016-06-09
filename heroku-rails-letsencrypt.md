# Heroku/Rails/Let's Encrypt

## Subdomain

```sh
heroku domains

> secure-example.herokuapp.com
```

```sh
heroku domains:add secure.example.com
```

```sh
dig CNAME secure.example.com

> secure.example.com.	300	IN	CNAME	secure-example.herokuapp.com.
```

```sh
host secure-example.herokuapp.com

> secure-example.herokuapp.com is an alias for us-east-1-a.route.herokuapp.com.
```

# Certificate

```sh
brew install certbot
sudo certbot certonly --manual --email admin@example.com -d example.com -d secure.example.com -d …
```

Follow “Make sure your web server displays the following content at…” instructions.

```ruby
# app/controllers/application_controller.rb:

class ApplicationController < ActionController::Base
  def certbot
    render text: 'Gxm0lVVJBKZaZKVfScLb3PqiUtgHuX3OeR70aZbWUal.aJoTzhaNvUgjojL…'
  end
end
```

```ruby
# config/routes.rb:

get '/.well-known/acme-challenge/Gxm0lVVJ…0aZbWUal' => 'application#certbot'
```

Push to Heroku and check URL:

```sh
curl http://secure.example.com/.well-known/acme-challenge/Gxm0lVVJ…0aZbWUal

> Gxm0lVVJBKZaZKVfScLb3PqiUtgHuX3OeR70aZbWUal.aJoTzhaNvUgjojLqEJn-Fxob1O73VdnL…
```

Press ENTER to continue validation. The keys will be created:

```sh
sudo heroku certs:add /etc/letsencrypt/live/secure.example.com/fullchain.pem /etc/letsencrypt/live/secure.example.com/privkey.pem
```

Copy the endpoint from:

```sh
heroku certs:info

> Fetching SSL Endpoint example-123.herokussl.com info for secure-example... done
```

And add it to the DNS server.

```sh
dig CNAME secure.example.com

> secure.example.com.	300	IN	CNAME	example-123.herokussl.com.
```

```sh
curl -I https://secure.example.com

> HTTP/1.1 200 OK
```

Force SSL:

```ruby
# config/environments/production.rb:

config.force_ssl = true
```

```sh
curl -I http://secure.example.com

> HTTP/1.1 301 Moved Permanently
```

## Renew

```sh
sudo certbot renew
```

## References

http://collectiveidea.com/blog/archives/2016/01/12/lets-encrypt-with-a-rails-app-on-heroku/
https://devcenter.heroku.com/articles/ssl-endpoint
