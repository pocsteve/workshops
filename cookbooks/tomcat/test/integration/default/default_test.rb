if os.family == 'redhat'
  describe package 'java-1.7.0-openjdk-devel' do
    it { should be_installed }
  end
elsif os.family == 'debian'
  describe package 'openjdk-8-jdk' do
    it { should be_installed }
  end
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  its('group') { should eq 'tomcat' }
  its('shell') { should eq '/bin/nologin' }
  its('home') { should eq '/opt/tomcat-8.5.45' }
end

describe directory('/opt/tomcat-8.5.45') do
  its('group') { should eq 'tomcat' }
end

describe directory('/opt/tomcat-8.5.45/conf') do
  its('mode') { should cmp '0750' }
end

%w( webapps work temp logs ).each do |subdir|
  describe directory("/opt/tomcat-8.5.45/#{subdir}") do
    its('owner') { should eq 'tomcat' }
    its('group') { should eq 'tomcat' }
  end
end

describe file('/etc/systemd/system/tomcat.service') do
  it { should exist }
end

describe systemd_service('tomcat.service') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe http('http://localhost:8080') do
  its('status') { should cmp 200 }
end

describe bash('ps -ef|grep tomcat') do
  its('stdout') { should match /tomcat-8.5.45/ }
end
