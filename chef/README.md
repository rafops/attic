# Chef

## Hello World

```
vagrant box add bento/ubuntu-16.04 --provider=virtualbox
vagrant init bento/ubuntu-16.04
vagrant up
vagrant ssh
```

Install [ChefDK](https://github.com/chef/chef-dk):

```
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk
```

Basic recipe with one resource:

```ruby
# hello.rb
file '/vagrant/hello.txt' do
    content 'Hello, eh?'
end
```

```
sudo chef-client --local-mode hello.rb
```

or:

```
sudo chef-client -z hello.rb
```


## Cookbooks

It is a good practice to prefix a cookbook with company's name:

```
mkdir cookbooks
chef generate cookbook cookbooks/acme-workstation
```

```
sudo chef-client -z cookbooks/acme-workstation/recipes/setup.rb
```

Installing Apache:

```ruby
package 'httpd'

file '/var/www/html/index.html' do
    content '<h1>Hello, eh?</h1>'
end

service 'httpd' do
    action [ :enable, :start ]
end
```

Run cookbook:

```
sudo chef-client -z --runlist "cookbook::recipe"
```

Example:

```
sudo chef-client -z --runlist "apache::server"
```

or:

```
sudo chef-client -z -r "apache::server"
```

Common syntax:

```
sudo chef-client -z -r "recipe[apache::server],recipe[cookbook::recipe],…"
```

Or inside `recipes/default.rb`:

```ruby
include_recipe 'cookbook::recipe'
```

Then run the default recipe:

```
sudo chef-client -z -r "recipe[coobook]"
```


## Recipes

```
chef generate recipe cookbooks/acme-workstation setup
```


## Dependency Management

```ruby
# cookbooks/acme-workstation/metadata.rb
depends 'application_ruby', '~> 4.1.0'
```

```
berks install
```


## Ohai


```
ohai memory/total
ohai cpu/0/mhz
```


## Templates

Generate a template:

```
chef generate template cookbooks/foobar templatefile
```

Generates `cookbooks/foobar/templates/templatefile.erb`.

Generate a cookbook file:

```
chef generate file cookbooks/acme-workstation amazing
```


## Built-in Ruby

Execute chef's ruby:

```
chef exec ruby …
```

Chef's gem:

```
chef gem …
```


## Testing

Run spec:

```
chef exec rspec
```

Create vm:

```
kitchen create
```

```
kitchen list
```

Run the tests:

```
kitchen converge
kitchen verify
```

SSH:

```
kitchen login
```

Unit tests with ChefSpec:

```
chef exec rspec
```

References:

- [ChefSpec examples](https://github.com/sethvargo/chefspec/tree/master/examples)
- [InSpec Resources Reference](https://www.inspec.io/docs/reference/resources/)


## Starter kit

Setup and maintain multiple nodes.

Create [free Chef server account](https://manage.chef.io/login).

Download starter kit.

The `chef-repo` (starter kit) contains a `.chef` directory with knife and a private key.

Check server connectivity:

```
knife client list
knife ssl check
```

Upload cookbook:

```
knife upload cookbooks/starter
```

List cookbooks on the server:

```
knife cookbook list
```


## Multi-machine

Vagrant [multi-machine](https://www.vagrantup.com/docs/multi-machine/).


## Bootstrapping

```bash
node_name='app1'
ssh_port=`vagrant ssh-config $node_name | grep '^\s\+Port' | awk '{print $2}'`
identity_file=`vagrant ssh-config $node_name | grep '^\s\+IdentityFile' | awk '{print $2}'`

knife bootstrap localhost --ssh-port $ssh_port --ssh-user vagrant --sudo --identity-file $identity_file -N $node_name
```

It installs the chef-client, runs ohai, converges the node and saves the node object to the Chef Server.


## Nodes

List nodes:

```
knife node list
```

```
knife node show app1
```

Show load balancer members attribute:

```
knife node show web -a haproxy.members
```

Free memory:

```
knife node show web -a memory.free
```

Cookbooks:

```
knife node show web -a cookbooks
```


## Run List

Upload cookbook and its dependencies:

```
cd cookbooks/acme-application
berks install
berks upload
cd -
```

Update `metadata.rb` version before uploading changes or:

```
berks upload --force
```

Show uploaded cookbooks and dependencies:

```
knife cookbook list
```

```
knife node run_list add app1 "recipe[acme-application]"
knife node show app1
```

```
vagrant ssh app1
```

```
sudo chef-client
```

Update run list:

```
knife node run_list set acme-application "recipe[another-cookbook],recipe[original-cookbook]"
```


## Load Balancer

Create a wrapper cookbook:

```ruby
# acme-load-balancer/recipes/default.rb
node.default['haproxy']['members'] = …
```

Bootstrap node:

```bash
node_name='web'
ssh_port=`vagrant ssh-config $node_name | grep '^\s\+Port' | awk '{print $2}'`
identity_file=`vagrant ssh-config $node_name | grep '^\s\+IdentityFile' | awk '{print $2}'`

knife bootstrap localhost --ssh-port $ssh_port --ssh-user vagrant --sudo --identity-file $identity_file -N $node_name --run-list "recipe[acme-load-balancer]"
```


## Roles

```ruby
# roles/load-balancer.rb
name "load-balancer"
description "Load balancer role"
run_list "recipe[acme-load-balancer]"
```

```
knife role from file roles/load-balancer.rb
```

```
knife role list
```

```
knife node run_list set web "role[load-balancer]"
```

```
vagrant ssh web
```

```
sudo chef-client
```


## SSH

Convergence without vagrant's SSH:

```bash
node_name='web'
ssh_port=`vagrant ssh-config $node_name | grep '^\s\+Port' | awk '{print $2}'`
identity_file=`vagrant ssh-config $node_name | grep '^\s\+IdentityFile' | awk '{print $2}'`

knife ssh localhost 'sudo chef-client' --manual-list --ssh-port $ssh_port --ssh-user vagrant --identity-file $identity_file
# knife ssh localhost 'sudo chef-client' --m …
```

Cloud nodes with user/password:

```
knife ssh "*:*" -x chef -P chef "sudo chef-client"
```

All nodes with role application:

```
knife ssh "role:application" …
```


## Search

```
knife search node "app*"
knife search node "role:application"
```

This can be used by the load balancer to discover nodes:


```ruby
# acme-load-balancer/recipes/default.rb
application_nodes = search('index', "role:application AND chef_environment:#{node.chef_environment}")
node.default['haproxy']['members'] = application_nodes.map do |member|
  {
    'hostname'  => member['hostname'],
    'ipaddress' => member['ipaddress'],
    'port'      => 8000,
    # …
  }
end

include_recipe "haproxy::manual"
```


## Environments

Staging, Production, …

```
knife environment list
```

```ruby
# environments/production.rb
name 'production'
description 'Production environment'
cookbook 'application', '= 0.1.4'
cookbook 'load-balancer', '= 0.1.0'
default_attributes({
  # useful variables for production environment
})
```

```
knife environment from file environments/production.rb
```

```
knife node environment set app1 production
```

Converges…


# Data Bags

```
mkdir -p data_bags/users
knife data bag create users
touch data_bags/users/user1.json
```

```
knife data bag from file users data_bags/users/user1.json
```

```
knife data bag show users user1
```

```
knife search users "*:*"
```

Create users:

```ruby
# user 'user1'
search('users').each do |u|
  user u['id']
end
```

Each data bag creates a new index on the Chef Server.

Encrypted data bags:

```
openssl rand -base64 512 | tr -d '\r\n' > secret-key
```

```
knife data bag create secret-users --secret-file secret-key
```

```
knife data bag from file secret-users data_bags/users/user2.json --secret-file secret-key
```

```
knife data bag show secret-users user2
```

Decrypt:

```
knife data bag show secret-users user2 --secret-file secret-key
```

Use client.pem as secret key, as it is already provided with chef-repo and available on nodes at `/etc/chef/client.pem`.

See: knife vault.


## Glossary

- **Attribute**: Node configuration.
- **Berkshelf**: Dependency manager for cookbooks.
- **Chef Client**: Configuration client.
- **Chef Server**: Configuration server.
- **Chef Spec**: Unit tests.
- **Cookbook**: Organize and distribute Recipes.
- **Data Bag**: Store configuration data independently from Nodes or Cookbooks.
- **Environment**: Define cookbooks versions.
- **Foodcritic**: Lint tool for cookbooks.
- **Knife**: Agent to interact with Chef Server.
- **Node**: Instance managed by chef.
- **Ohai**: System details discovery.
- **Recipe**: Runnable and reusable Resources.
- **Resource**: Define a desired system state.
- **Role**: Logical grouping of cookbooks and other roles.
- **Test Kitchen**: Integration tests.
- **Wrapper Cookbook**: A cookbook that utilize dependencies and define attribute values.
