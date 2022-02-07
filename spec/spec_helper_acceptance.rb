require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  if fact_on(host, 'osfamily') == 'RedHat'
    install_module_from_forge_on(host, 'puppet/epel', '>= 3.0.0')
  end
  host.install_package('puppet-bolt')
end
