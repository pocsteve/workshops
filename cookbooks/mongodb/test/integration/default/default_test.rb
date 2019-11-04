# frozen_string_literal: true

# describe package('mongodb-org') do
#   it { should be_installed }
# end

# # describe yum.repo('mongodb') do
# #   it { should exist }
# #   it { should be_enabled }
# # end

# # This is an example test, replace it with your own test.
# describe port(27_017) do
#   it { should be_listening }
# end

# describe service('mongod') do
#   it { should be_installed }
#   it { should be_enabled }
#   it { should be_running }
# end

describe command('mongo') do
  its('exit_status') { should eq 0 }
end
