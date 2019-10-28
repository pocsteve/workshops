describe bash('/opt/tomcat/bin/version.sh') do
  its('stdout') { should match /Server number:  8.5.45.0/ }
end

describe http('http://localhost:8080') do
  its('status') { should cmp 200 }
end
