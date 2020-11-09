require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_module_from_forge_on(host, 'camptocamp/systemd', '>= 2.0.0 < 3.0.0')

  case fact_on(host, 'operatingsystem')
  when 'CentOS'
    host.install_package('epel-release')
  when 'Ubuntu'
    host.install_package('software-properties-common')
  end
  host.install_package('puppet-bolt')
end
