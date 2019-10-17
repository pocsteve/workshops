# frozen_string_literal: true

yum_repository 'mongodb' do
  action :create
  description node['mongodb']['description']
  baseurl node['mongodb']['baseurl']
  gpgcheck node['mongodb']['gpgcheck']
  enabled node['mongodb']['enabled']
end

yum_package 'mongodb-org'

service 'mongod' do
  action [:enable, :start]
end
