require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      if fact_on(host, 'operatingsystem') == 'Ubuntu'
        host.install_package('software-properties-common')
      end
      host.install_package('puppet-bolt')
    end
  end
end
