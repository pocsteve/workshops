include_recipe 'ark'

# Build Ruby
%w( build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3 ).each do |pkg|
  apt_package(pkg.to_s)
end

directory '/tmp/ruby'

ark 'ruby' do
  # url "http://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.gz"
  url "http://cache.ruby-lang.org/pub/ruby/#{node['ruby']['version']}/ruby-2.1.#{node['ruby']['patch-level']}.tar.gz"
  # url "http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.8.tar.gz"
  path '/tmp/ruby'
  prefix_root '/tmp/ruby'
  # version '2.4.1'
  version "#{node['ruby']['version']}.#{node['ruby']['patch-level']}"
  # version '2.3.8'
end

bash('configure_ruby') do
  cwd ::File.dirname("/tmp/ruby/ruby-#{node['ruby']['version']}.#{node['ruby']['patch-level']}/configure")
  # cwd ::File.dirname('/tmp/ruby/ruby-2.3.8/configure')
  code <<-EOH
    sudo ./configure
    sudo make install
    sudo cp /usr/local/bin/ruby /usr/bin/ruby
    sudo cp /usr/local/bin/gem /usr/bin/gem
    EOH
  not_if { ::File.exist?('/usr/bin/gem') }
end

directory '/tmp/ruby' do
  recursive true
  action :delete
end
