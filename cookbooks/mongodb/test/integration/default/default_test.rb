if os.family == 'redhat'
  describe yum.repo('mongodb') do
    it { should exist }
    it { should be_enabled }
  end
elsif os.family == 'debian'
  describe file('/etc/apt/sources.list.d/mongodb-org-4.2.list') do
    it { should exist }
  end
end

describe package('mongodb-org') do
  it { should be_installed }
end

describe service('mongod') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
