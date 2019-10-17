# install java-7
yum_package 'java-1.7.0-openjdk-devel' 

# configure tomcat user and group
group 'tomcat'
user 'tomcat' do
  gid node['tomcat']['group']
  home node['tomcat']['home_dir']
  shell node['tomcat']['shell']
end

# download tomcat
remote_file '/tmp/apache-tomcat-8.5.47.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz'
end

# create tomcat directory
directory "#{node['tomcat']['home_dir']}" do
  group node['tomcat']['group']
end

# extract the tomcat archive - NOTE: no symbol available representing required extraction flags available so using execute resource
# archive_file '/tmp/apache-tomcat-8.5.47.tar.gz' do
#   destination node['tomcat']['home_dir']
#   options [:fflags]
#   overwrite true
# end

bash 'extract tomcat archive' do
  # cwd ::File.dirname('/tmp')
  code <<-EOH
    tar xvf /tmp/apache-tomcat-8*tar.gz -C #{node['tomcat']['home_dir']} --strip-components=1
    EOH
  not_if { ::File.exist?("#{node['tomcat']['home_dir']}/conf") }
end

ruby_block 'set recursive group permissions' do
  block do
    FileUtils.chown_R('root', 'tomcat','/opt/tomcat')
    FileUtils.chmod_R(750,'/opt/tomcat/conf')
    FileUtils.chown_R('tomcat', 'tomcat', '/opt/tomcat/webapps')
    FileUtils.chown_R('tomcat', 'tomcat', '/opt/tomcat/work')
    FileUtils.chown_R('tomcat', 'tomcat', '/opt/tomcat/temp')
    FileUtils.chown_R('tomcat', 'tomcat', '/opt/tomcat/logs')
  end
end

# assign group permissions to tomcat sub-directories
# directory "#{node['tomcat']['home_dir']}/conf" do
#   mode node['tomcat']['mode']
# end
# directory "#{node['tomcat']['home_dir']}/webapps" do
#   owner node['tomcat']['user']
# end
# directory "#{node['tomcat']['home_dir']}/work" do
#   owner node['tomcat']['user']
# end
# directory "#{node['tomcat']['home_dir']}/temp" do
#   owner node['tomcat']['user']
# end
# directory "#{node['tomcat']['home_dir']}/logs" do
#   owner node['tomcat']['user']
# end

cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
end

systemd_unit 'tomcat.service' do
  action [ :enable, :start ]
  triggers_reload true
end
