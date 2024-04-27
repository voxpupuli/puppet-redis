# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # sysctl is untestable in docker
  install_puppet_module_via_pmt_on(host, 'puppet-augeasproviders_sysctl') unless host['hypervisor'] == 'docker'

  unless fact_on(host, 'os.name') == 'Debian' && fact_on(host, 'os.release.major').to_i >= 12
    # puppet-bolt for Debian 12 is not yet available
    host.install_package('puppet-bolt')
  end

  if fact_on(host, 'os.family') == 'Debian'
    # APT required for Debian based systems where `$redis::manage_repo` is `true`
    install_puppet_module_via_pmt_on(host, 'puppetlabs-apt')
  end
end
