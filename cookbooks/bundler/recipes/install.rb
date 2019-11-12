#
# Cookbook:: bundler
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
execute 'clone middleman-blog' do
  cwd '/etc'
  command "sudo git clone #{node['bundler']['repo']}"
  not_if { ::File.directory?('/etc/middleman-blog') }
end

# Install Bundler
gem_package 'bundler' do
  version  node['bundler']['version']
end

# sudo 'passwordless-access' do - not available in v13.
#   commands ['bundle install']
#   nopasswd true
# end

# Install project dependencies
user node['bundler']['user'] do
  comment 'user to run bundler'
  home "/home/#{node['bundler']['user']}"
  group 'sudo'
  system true
end

directory "/home/#{node['bundler']['user']}" do
  owner node['bundler']['user']
end

execute 'install bundler' do
  cwd '/etc/middleman-blog'
  command 'sudo bundle install'
  user node['bundler']['user']
  # not_if ...
end
