yum_repository 'mongodb' do
  action :create
  baseurl node['mongodb']['baseurl']
  gpgcheck node['mongodb']['gpgcheck']
  enabled node['mongodb']['enabled']
end

replace_or_add 'repo name' do
  path '/etc/yum.repos.d/mongodb.repo'
  pattern 'name='
  line 'name=MongoDB Repository'
end

yum_package 'mongodb-org'

service 'mongod' do
  action [ :enable, :start]
end
