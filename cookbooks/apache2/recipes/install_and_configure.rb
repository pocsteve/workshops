apt_package('apache2')

# Configure apache
bash('configure_apache') do
  code <<-EOH
    sudo a2enmod proxy_http
    sudo a2enmod rewrite
   EOH
end

service 'apache2' do
  action %i(enable start)
end
