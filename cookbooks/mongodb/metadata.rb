name 'mongodb'
maintainer 'Steve Fraser'
maintainer_email 'sfraser@chef.io'
license 'All Rights Reserved'
description 'Installs/Configures mongodb'
version '0.4.0'
chef_version '>= 14.0'

%w( redhat centos ubuntu ).each do |os|
  supports os
end

issues_url 'https://github.com/pocsteve/workshops/issues'
source_url 'https://github.com/pocsteve/workshops'
