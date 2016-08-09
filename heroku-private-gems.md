# Heroku Private Gems

Fork [https://github.com/debitoor/ssh-private-key-buildpack](`ssh-private-key-buildpack`).

Create a Rails test application:

```sh
mkdir testapp
cd testapp

bundle exec rails new . --skip-active-record --skip-sprockets --skip-javascript --skip-turbolinks --skip-spring --skip-test-unit --no-rc --force

git init .
git add .
git commit -m "first commit"
```

Create a test application on Heroku:

```sh
heroku apps:create testapp
```

Push testapp to Heroku:

```sh
git push heroku master
```

Add `ssh-private-key-buildpack` to testapp:

```sh
heroku buildpacks:set --index 1 https://github.com/debitoor/ssh-private-key-buildpack
heroku buildpacks:add heroku/ruby
```

Create a deployment key:

```sh
ssh-keygen -t rsa -f id_rsa_github -N ''
```

Upload public key (`id_rsa_github.pub`) to the gem repository:

```
https://github.com/org/some_private_gem/settings/keys
```

Add private key to Heroku config:

```sh
heroku config:set SSH_KEY=`cat id_rsa_github | base64`
```

Add private gem to Gemfile:

```ruby
gem 'privategem', git: "git@github.com:org/some_private_gem.git"
```

Install gem:

```sh
bundle install
```

Commit:

```
git add Gemfile*
git commit -m "added private gem"
```

Push to Heroku:

```sh
git push heroku master
```
