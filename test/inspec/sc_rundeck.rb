# tests for rundeck
# installed?
describe package('rundeck') do
 it { should be_installed }
end

# running in supervisor?
describe command('supervisorctl status rundeckd') do
  its('stdout') { should match 'RUNNING'}
end

# GUI available?
describe http('http://localhost:4440/user/login') do
  its('status') { should cmp 200 }
end

##################################################
# is consul running?
describe command('supervisorctl status consul') do
  its('stdout') { should match 'RUNNING'}
end



# tests for consul-template
# running in supervisor?
describe command('supervisorctl status rundeck-node-consul-example.com') do
  its('stdout') { should match 'RUNNING'}
end


# does resources.xml exist?
describe file('/var/lib/rundeck/projects/example.com/etc/resources.xml') do
  its('content') { should match 'name="example"' }
  its('content') { should match 'description="example.com"' }
  its('content') { should match 'username="scjobs"' }
  its('content') { should match 'hostname="127.0.0.1"' }
end