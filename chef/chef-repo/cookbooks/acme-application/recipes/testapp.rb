#
# Cookbook:: acme-application
# Recipe:: testapp
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# include_recipe "rbenv::default"
# include_recipe "rbenv::ruby_build"
#
# rbenv_ruby "2.4.1"

directory '/srv/testapp' do
  recursive true
end

cookbook_file '/srv/testapp/config.ru' do
  source 'config.ru'
end
cookbook_file '/srv/testapp/Gemfile' do
  source 'Gemfile'
end

package 'ruby'

application '/srv/testapp' do
  # ruby_gem 'rack'
  # rackup do
  #   port 8000
  # end

  ruby_gem 'bundler'
  bundle_install do
    vendor true
  end
  # ruby_execute 'bundle exec rackup --port 8000 --host 0.0.0.0'
  rackup do
    port '8000 --host 0.0.0.0'
  end
end
