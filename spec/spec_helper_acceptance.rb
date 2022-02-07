require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'operatingsystem') == 'CentOS'
    host.install_package('epel-release')
  end
  host.install_package('puppet-bolt')
end
