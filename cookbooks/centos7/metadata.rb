name 'centos7'
maintainer 'Steve Fraser'
maintainer_email 'sfraser@chef.io'
license 'All Rights Reserved'
description 'Configures standard centos7 security settings'
version '0.4.3'
chef_version '>= 14.0'

depends 'audit'

%w( redhat centos ).each do |os|
  supports os
end

issues_url 'https://github.com/pocsteve/workshops/issues_url'
source_url 'https://github.com/pocsteve/workshops'
