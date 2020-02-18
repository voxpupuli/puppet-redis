require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module_on(hosts)
install_module_dependencies_on(hosts)
install_module_from_forge('camptocamp/systemd', '>= 2.0.0 < 3.0.0')

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      case fact_on(host, 'operatingsystem')
      when 'CentOS'
        host.install_package('epel-release')
      when 'Ubuntu'
        host.install_package('software-properties-common')
      end
      host.install_package('puppet-bolt')
    end
  end
end
