# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # sysctl is untestable in docker
  install_module_from_forge_on(host, 'herculesteam/augeasproviders_sysctl', '>= 2.1.0 < 3.0.0') unless host['hypervisor'] == 'docker'

  install_module_from_forge_on(host, 'puppet/epel', '>= 3.0.0') if fact_on(host, 'osfamily') == 'RedHat' && fact_on(host, 'operatingsystemmajrelease').to_i == 7
  unless fact_on(host, 'osfamily') == 'RedHat' && fact_on(host, 'operatingsystemmajrelease').to_i >= 9
    # puppet-bolt rpm for CentOS 9 is not yet available
    # https://tickets.puppetlabs.com/browse/MODULES-11275
    host.install_package('puppet-bolt')
  end

  if fact_on(host, 'osfamily') == 'Debian'
    # APT required for Debian based systems where `$redis::manage_repo` is `true`
    install_module_from_forge_on(host, 'puppetlabs/apt', '>= 9.0.0')

    if Gem::Version.new(fact_on(host, 'facterversion')) < Gem::Version.new('4.0.0')
      # Install prerequisites where Facter 3 is used
      host.install_package('lsb-release')
    end
  end
end
