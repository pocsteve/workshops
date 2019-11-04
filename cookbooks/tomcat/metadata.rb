name 'tomcat'
maintainer 'Steve Fraser'
maintainer_email 'sfraser@chef.io'
license 'All Rights Reserved'
description 'Installs/Configures tomcat'
version '0.5.0'

chef_version '>= 14.0'

depends 'ark'

%w( redhat centos ubuntu).each do |os|
  supports os
end

issues_url 'https://github.com/pocsteve/workshops/issues'
source_url 'https://github.com/pocsteve/workshops'
