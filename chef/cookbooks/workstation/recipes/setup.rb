# package 'tree' do
#     action :install
# end
#
# package 'ntp' # default action is install
# package 'git' do
#     action :install
# end
#
# #file '/etc/motd' do
# #    content 'cool stuff'
# #    action :create
# #    owner 'root'
# #    group 'root'
# #end
#
# cookbook_file '/vagrant/amazing' do
#   source 'amazing'
#   mode '0777'
#   # action :create
# end
#
# template '/etc/motd' do
#   source 'motd.erb'
#   variables(
#     current_time: Time.now
#   )
#   action :create
# end
#
# # service 'ntpd' do
# #     action [ :enable, :start ]
# # end
#
# # bash "inline script" do
# #   user "root"
# #   code "mkdir /vagrant/rootowned && chmod 700 /vagrant/rootowned"
# #   # define idempotence for this bash resource
# #   not_if do
# #     File.exists? '/vagrant/rootowned' and File.directory? '/vagrant/rootowned'
# #   end
# #   # not_if '[ -d "/vagrant/rootowned" ]'
# # end
#
# execute "run a command" do
#   command <<-EOH
#     mkdir /vagrant/rootowned
#     chmod 700 /vagrant/rootowned
#   EOH
#   not_if do
#     File.exists? '/vagrant/rootowned' and File.directory? '/vagrant/rootowned'
#   end
# end
#
# directory "/vagrant/an/other/dir" do
#   owner "root"
#   recursive true
#   mode "700"
# end
user 'chefuser'
