#!/bin/bash
export PATH=/opt/puppetlabs/bin:$PATH
sed -i -e "s/nodaemon=true/nodaemon=false/" /etc/supervisord.conf
/usr/local/bin/supervisord -c /etc/supervisord.conf
echo "Running in $(pwd)"
echo "Puppet Version: $(puppet -V)"


# configure puppet
ln -sf $(pwd)/test/hiera.yaml $(puppet config print confdir |cut -d: -f1)/
curl -s https://gitlab.scale.sc/scalecommerce/postinstall/raw/master/puppet.conf > $(puppet config print confdir |cut -d: -f1)/puppet.conf
ln -sf $(pwd)/test/hieradata $(puppet config print confdir |cut -d: -f1)/hieradata
puppet config set certname puppet-test.scalecommerce

# install puppet modules
puppet module install ajcrowe-supervisord
puppet module install puppetlabs-apt --version 2.4.0
puppet module install puppetlabs-inifile --version 1.6.0
# installation of rundeck module moved to gitlab-ci jobs cause we do need different versions for puppet 3, 4, 5
#puppet module install puppet-rundeck --version 4.0.0
puppet module install puppet-rundeck --version 5.4.0 --ignore-dependencies
puppet module install KyleAnderson-consul
puppet module install gdhbashton-consul_template
git clone https://github.com/ScaleCommerce/puppet-supervisor_provider.git $(puppet config print modulepath |cut -d: -f1)/supervisor_provider
git clone https://github.com/ScaleCommerce/puppet-sc_java.git $(puppet config print modulepath |cut -d: -f1)/sc_java
git clone https://github.com/ScaleCommerce/puppet-sc_supervisor.git $(puppet config print modulepath |cut -d: -f1)/sc_supervisor

ln -sf $(pwd) $(puppet config print modulepath |cut -d: -f1)/sc_rundeck


ln -sf ./test/document_roots /var/www
curl -s https://omnitruck.chef.io/install.sh | bash -s -- -P inspec

apt-get update
