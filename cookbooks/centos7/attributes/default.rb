# frozen_string_literal: true

default['audit']['fetcher'] = 'chef-server'
default['audit']['reporter'] = 'chef-server-automate'
# default['audit']['profiles']['cis-centos7-level1-server'] = { compliance: 'admin/cis-centos7-level1-server' }
default['audit']['profiles']['my-centos'] = { compliance: 'admin/my-centos' }

# default['audit']['profiles'] = [
#   {
#     name: 'CIS CentOS Linux 7 Benchmark Level 1 - Server',
#     compliance: 'admin/cis-centos7-level1-server',
#   },
# ]
