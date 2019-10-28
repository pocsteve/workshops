# install java
yum_package "java-#{node['tomcat']['openjdk-version']}-openjdk-devel"

# configure tomcat user and group
group node['tomcat']['group']
user node['tomcat']['user'] do
  gid node['tomcat']['group']
  home node['tomcat']['home_dir']
  shell node['tomcat']['shell']
end

# download tomcat
# remote_file Chef::Config[:file_cache_path] + "#{node['tomcat']['version']}.tar.gz" do
remote_file "/tmp/apache-tomcat-#{node['tomcat']['version']}.tar.gz" do
  source "https://archive.apache.org/dist/tomcat/tomcat-#{node['tomcat']['major-version']}/v#{node['tomcat']['version']}/bin/apache-tomcat-#{node['tomcat']['version']}.tar.gz"
end

# create the tomcat home directory
directory node['tomcat']['home_dir'] do
  group node['tomcat']['group']
end

# extract the downloaded tomcat archive to the tomcat home directory
bash 'extract tomcat archive' do
  # cwd ::File.dirname('/tmp')
  code <<-EOH
    tar xvf "/tmp/apache-tomcat-#{node['tomcat']['version']}.tar.gz" -C #{node['tomcat']['home_dir']} --strip-components=1
  EOH
  not_if { ::File.exist?("#{node['tomcat']['home_dir']}/conf") }
end

# configure tomcat directory ownership and permissions
ruby_block 'set recursive ownership & permissions' do
  block do
    FileUtils.chown_R('root', node['tomcat']['group'], node['tomcat']['home_dir'])
    FileUtils.chmod_R(node['tomcat']['permissions'], "#{node['tomcat']['home_dir']}/conf")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/webapps")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/work")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/temp")
    FileUtils.chown_R(node['tomcat']['user'], node['tomcat']['group'], "#{node['tomcat']['home_dir']}/logs")
  end
end

# establish the Systemd unit file for Tomcat in proper dir
cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
end

# Reload Systemd to load Tomcat unit file
systemd_unit 'tomcat.service' do
  action %i(enable start)
  triggers_reload true
end
