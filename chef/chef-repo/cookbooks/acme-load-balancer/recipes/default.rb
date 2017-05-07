#
# Cookbook:: acme-load-balancer
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.default['haproxy']['members'] = [{
  "hostname" => "app1",
  "ipaddress" => "192.168.33.10",
  "port" => 8000,
  "ssl_port" => 8443
}, {
  "hostname" => "app2",
  "ipaddress" => "192.168.33.11",
  "port" => 8000,
  "ssl_port" => 8443
}]

include_recipe "haproxy::manual"
