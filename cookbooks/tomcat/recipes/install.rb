# assign attributes to variables to improve readability
tomcat_user = node['tomcat']['user']
tomcat_group = node['tomcat']['group']
tomcat_dir = node['tomcat']['home_dir']
tomcat_shell = node['tomcat']['shell']

# install java-7
yum_package 'java-1.7.0-openjdk-devel' 

# configure tomcat user and group
group tomcat_group
user tomcat_user do
  gid tomcat_group
  home tomcat_dir
  shell tomcat_shell
end

# download tomcat
remote_file '/tmp/apache-tomcat-8.5.47.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.47/bin/apache-tomcat-8.5.47.tar.gz'
end

# create the tomcat home directory
directory tomcat_dir do
  group tomcat_group
end

# extract the downloaded tomcat archive to the tomcat home directory
bash 'extract tomcat archive' do
  # cwd ::File.dirname('/tmp')
  code <<-EOH
    tar xvf /tmp/apache-tomcat-8*tar.gz -C #{node['tomcat']['home_dir']} --strip-components=1
    EOH
  not_if { ::File.exist?("#{tomcat_dir}/conf") }
end

# configure tomcat directory ownership and permissions
ruby_block 'set recursive ownership & permissions' do
  block do
    FileUtils.chown_R('root', tomcat_group, tomcat_dir)
    FileUtils.chmod_R(750, "#{tomcat_dir}/conf")
    FileUtils.chown_R(tomcat_user, tomcat_group, "#{tomcat_dir}/webapps")
    FileUtils.chown_R(tomcat_user, tomcat_group, "#{tomcat_dir}/work")
    FileUtils.chown_R(tomcat_user, tomcat_group, "#{tomcat_dir}/temp")
    FileUtils.chown_R(tomcat_user, tomcat_group, "#{tomcat_dir}/logs")
  end
end

# establish the Systemd unit file for Tomcat in proper dir
cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
end

# Reload Systemd to load Tomcat unit file
systemd_unit 'tomcat.service' do
  action [ :enable, :start ]
  triggers_reload true
end
