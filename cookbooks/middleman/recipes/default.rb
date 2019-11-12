#
# Cookbook:: middleman
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# Update apt-get
apt_update 'update' do
  action :update
end

# Install Git
apt_package('git')

include_recipe 'ruby::install_and_configure'
include_recipe 'apache2::install_and_configure'
include_recipe 'bundler::install'

file('/etc/apache2/sites-enabled/000-default') do
  action :delete
end

bash 'Install thin service' do
  code <<-EOH
      thin install
      /usr/sbin/update-rc.d -f thin defaults
      EOH
end

template '/etc/apache2/sites-enabled/blog.conf' do
  source 'blog.conf.erb'
  notifies :restart, 'service[apache2]', :immediate
end

template '/etc/thin/blog.yml' do
  source 'blog.yml.erb'
  variables(
    project_install_directory: '/etc/middleman-blog'
  )
end

template '/etc/init.d/thin' do
  source 'thin.erb'
  variables(
    home_directory: "/home/#{node['bundler']['user']}"
  )
  # notifies :restart, 'service[thin]', :immediately
end

service 'thin' do
  action [ :enable, :start ]
end
