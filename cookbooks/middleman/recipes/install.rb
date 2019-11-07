########################################
# Notes:
# replaced package 'git-core' with 'git' 
# -ref: http://blog.tap349.com/chef/2017/08/02/chef-troubleshooting/#git-core-is-a-virtual-package-provided-by-multiple-packages-you-must-explicitly-select-one
# replaced ruby-'2.1.3' with '2.5.1' 
# -ref: https://github.com/rbenv/ruby-build/issues/1207
# bundler defaults to v2.2.  middleman-core requires v1.1
#########################################
include_recipe 'ark'

# Update apt-get
apt_update 'update' do
  action :update
end

# Build Ruby
%w( build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3 ).each do |pkg|
  apt_package("#{pkg}")
end

directory '/tmp/ruby'

ark 'ruby' do
  url "http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz"
  #url "http://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.gz"
  path '/tmp/ruby'
  prefix_root '/tmp/ruby'
  # version '2.4.1'
  version '2.1.3'

end

bash ('configure_ruby') do
  cwd ::File.dirname('/tmp/ruby/ruby-2.1.3/configure')
  code <<-EOH
    sudo ./configure
    sudo make install
    sudo cp /usr/local/bin/ruby /usr/bin/ruby
    sudo cp /usr/local/bin/gem /usr/bin/gem
    EOH
  not_if { ::File.exist?('/usr/bin/gem')}
end

directory '/tmp/ruby' do
  recursive true
  action :delete
end

# Install apache
apt_package('apache2')

# Configure apache
bash ('configure_apache') do
  code <<-EOH
    sudo a2enmod proxy_http
    sudo a2enmod rewrite
   EOH
end

file ('/etc/apache2/sites-enabled/000-default') do
  action :delete
end

template '/etc/apache2/sites-enabled/blog.conf' do
  source 'blog.conf.erb'
  notifies :restart, 'service[apache2]', :immediate
end

service 'apache2' do
  action %i(enable start)
end
  

# Install Git
apt_package('git')

directory '/etc/learnchef/middleman' do
  mode '0775'
  recursive true
end

# Clone the repo
git '/etc/learnchef/middleman' do
  repository 'https://github.com/learnchef/middleman-blog.git'
  action :checkout
end

# Install Bundler
gem_package 'bundler' do
  version '1.15.4'
end

# Install project dependencies
user 'bundler_user' do
  comment 'user to run bundler'
  home '/home/bundler_user'
  gid '27'
  system true
end

directory '/home/bundler_user' do
  owner 'bundler_user'
end

execute 'install bundler' do
  cwd '/etc/learnchef/middleman'
  command 'bundle install'
  # user 'bundler_user'
  # not_if ...
end

bash 'Install thin service' do
  code <<-EOH
    thin install
    /usr/sbin/update-rc.d -f thin defaults
    EOH
end
 
template '/etc/thin/blog.yml' do
  source 'blog.yml.erb'
end

template '/etc/thin/blog.conf' do
  source 'blog.conf.erb'
end

template '/etc/init.d/thin' do
  source 'thin.erb'
  variables(
    :home_directory => '/home/bundler_user'
  )
  notifies :restart, 'service[thin]', :immediately
end

service 'thin' do
  action [ :enable, :start ]
end
