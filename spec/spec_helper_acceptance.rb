require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  case fact_on(host, 'operatingsystem')
  when 'CentOS'
    host.install_package('epel-release')
  when 'Ubuntu'
    host.install_package('software-properties-common')
  end
  host.install_package('puppet-bolt')
end
