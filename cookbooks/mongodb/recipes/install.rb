# frozen_string_literal: true

case node['platform']
when 'centos'
  yum_repository 'mongodb' do
    action :create
    description node['mongodb']['description']
    baseurl node['mongodb']['baseurl']
    gpgcheck node['mongodb']['gpgcheck']
    enabled node['mongodb']['enabled']
  end

  yum_package 'mongodb-org'

when 'ubuntu'
  apt_repository 'mongodb-org-4.2' do
    arch 'amd64'
    uri 'http://repo.mongodb.org/apt/ubuntu'
    distribution 'bionic/mongodb-org/4.2'
    components ['multiverse']
    trusted true
  end

  apt_package 'mongodb-org'
end

service 'mongod' do
  action %i(enable start)
end
