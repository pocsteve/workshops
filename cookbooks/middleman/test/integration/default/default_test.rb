
# test apache
describe port(80) do
  it { should be_listening }
end

# test thin
describe port(3000) do
  it { should be_listening }
end

describe service('thin') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
