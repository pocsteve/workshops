describe bash('ps -ef|grep tomcat') do
  its('stdout') { should match /tomcat-8.5.47/ }
end

describe http('http://localhost:8080') do
  its('status') { should cmp 200 }
end
