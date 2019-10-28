# frozen_string_literal: true

default['tomcat']['group'] = 'tomcat'
default['tomcat']['home_dir'] = '/opt/tomcat'
default['tomcat']['shell'] = '/bin/nologin'
default['tomcat']['permissions'] = 0o750
default['tomcat']['user'] = 'tomcat'
default['tomcat']['major-version'] = '8'
default['tomcat']['version'] = '8.5.47'
default['tomcat']['openjdk-version'] = '1.7.0'
