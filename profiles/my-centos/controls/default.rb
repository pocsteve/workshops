# frozen_string_literal: true

control 'centos-sec-01A' do
  impact 0.7
  title 'Lock Down /etc/services'
  desc 'locking down critical files to prevent accidental deleting and overwriting by ensuring the immutable bit is set'
  describe bash('lsattr /etc/services') do
    its('stdout') { should match /--i--/ }
  end
end

control 'centos-sec-01B' do
  impact 0.7
  title 'Lock Down /etc/password'
  desc 'locking down critical files to prevent accidental deleting and overwriting by ensuring the immutable bit is set'
  describe bash('lsattr /etc/passwd') do
    its('stdout') { should match /--i--/ }
  end
end

control 'centos-sec-01C' do
  impact 0.7
  title 'Lock Down /etc/shadow'
  desc 'locking down critical files to prevent accidental deleting and overwriting by ensuring the immutable bit is set'
  describe bash('lsattr /etc/shadow') do
    its('stdout') { should match /--i--/ }
  end
end

control 'centos-sec-02A' do
  impact 0.7
  title 'Ensure all files in /home are set to 644'
  desc 'Prevent server hacks to files that have full permissions'
  describe bash('find /home -type f -perm 777') do
    its('stdout') { should eq '' }
  end
end
