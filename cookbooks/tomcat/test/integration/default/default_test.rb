if os.family == 'redhat'
  describe package 'java-1.7.0-openjdk-devel' do
    it { should be_installed }
  end
elsif os.family == 'debian'
  describe package 'openjdk-8-jre' do
    it { should be_installed }
  end
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  its('gid') { should eq 'tomcat' }
  its('shell') { should eq '/bin/nologin' }
  its('home') { should eq '/opt/tomcat-8.5.45' }
end

describe file('/etc/systemd/system/tomcat.service') do
  it { should exists }
end

describe http('http://localhost:8080') do
  its('status') { should cmp 200 }
end

describe bash('ps -ef|grep tomcat') do
  its('stdout') { should match /tomcat-8.5.45/ }
end
