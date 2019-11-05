# RHEL-base attributes
default['mongodb']['baseurl'] = 'https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/'
# default['mongodb']['baseurl'] = 'http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/'
default['mongodb']['gpgcheck'] = false
default['mongodb']['enabled'] = true

# Debian-based attributes
default['mongodb']['uri'] = 'http://repo.mongodb.org/apt/ubuntu'
default['mongodb']['distribution'] = 'bionic/mongodb-org/4.2'
default['mongodb']['components'] = 'multiverse'
default['mongodb']['trusted'] = true
default['mongodb']['version'] = '4.2'
default['mongodb']['arch'] = 'amd64'
