name 'mongodb'
maintainer 'Steve Fraser'
maintainer_email 'sfraser@chef.io'
license 'All Rights Reserved'
description 'Installs/Configures mongodb'
version '0.3.1'
chef_version '>= 14.0'

depends 'sc-mongodb'

%w( redhat centos ).each do |os|
  supports os
end

issues_url 'https://github.com/pocsteve/workshops/issues'
source_url 'https://github.com/pocsteve/workshops'
