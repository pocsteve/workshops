case node['platform']
when 'centos'
  yum_repository 'mongodb' do
    action :create
    description 'MongoDB Repository'
    baseurl node['mongodb']['baseurl']
    gpgcheck node['mongodb']['gpgcheck']
    enabled node['mongodb']['enabled']
  end

  yum_package 'mongodb-org'

when 'ubuntu'
  apt_repository "mongodb-org-#{node['mongodb']['version']}" do
    arch node['mongodb']['arch']
    uri node['mongodb']['uri']
    distribution node['mongodb']['distribution']
    components [(node['mongodb']['components']).to_s]
    trusted node['mongodb']['trusted']
  end

  apt_package 'mongodb-org'
end

service 'mongod' do
  action %i(enable start)
end
