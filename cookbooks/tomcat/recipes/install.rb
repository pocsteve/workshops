include_recipe 'ark'

# install java
yum_package "java-#{node['tomcat']['openjdk-version']}-openjdk-devel"

# configure tomcat user and group
group node['tomcat']['group']

ark 'tomcat' do
  url "https://archive.apache.org/dist/tomcat/tomcat-#{node['tomcat']['major-version']}/v#{node['tomcat']['version']}/bin/apache-tomcat-#{node['tomcat']['version']}.tar.gz"
  path node['tomcat']['parent_dir_path']
  prefix_root node['tomcat']['parent_dir_path']
  group node['tomcat']['group']
  version node['tomcat']['version']
  checksum node['tomcat']['checksum']
  notifies :stop, 'systemd_unit[tomcat.service]', :immediate
end

user node['tomcat']['user'] do
  gid node['tomcat']['group']
  home node['tomcat']['home_dir']
  shell node['tomcat']['shell']
end

# configure tomcat directory ownership and permissions
ruby_block 'set recursive ownership & permissions' do
  block do
    # FileUtils.chown_R('root', node['tomcat']['group'], node['tomcat']['home_dir'])
    FileUtils.chmod_R(node['tomcat']['permissions'], "#{node['tomcat']['home_dir']}/conf")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/webapps")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/work")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/temp")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/logs")
  end
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb' 
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
  notifies :restart, 'systemd_unit[tomcat.service]', :delayed
end

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  action :nothing
end

# Reload Systemd to load Tomcat unit file
systemd_unit 'tomcat.service' do
  action %i(enable start)
  triggers_reload true
end
