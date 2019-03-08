require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

def change_root_password
  on(hosts, 'echo "root:root" | chpasswd')
end

def install_bolt_on(hosts)
  on(hosts, "/opt/puppetlabs/puppet/bin/gem install winrm-fs -v '1.1.1' --no-ri --no-rdoc", acceptable_exit_codes: [0]).stdout
  on(hosts, "/opt/puppetlabs/puppet/bin/gem install bolt -v '0.5.1' --no-ri --no-rdoc", acceptable_exit_codes: [0]).stdout
end

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
change_root_password
install_module_on(hosts)
install_module_dependencies_on(hosts)

UNSUPPORTED_PLATFORMS = %w[windows AIX Solaris].freeze

DEFAULT_PASSWORD = if default[:hypervisor] == 'vagrant'
                     'root'
                   elsif default[:hypervisor] == 'docker'
                     'root'
                   end

def run_task(task_name:, params: nil, password: DEFAULT_PASSWORD)
  run_bolt_task(task_name: task_name, params: params, password: password)
end

def run_bolt_task(task_name:, params: nil, password: DEFAULT_PASSWORD)
  on(master, "/opt/puppetlabs/puppet/bin/bolt task run #{task_name} --modules /etc/puppetlabs/code/modules/ --nodes localhost --user root --password #{password} #{params}", acceptable_exit_codes: [0, 1]).stdout
end

def expect_multiple_regexes(result:, regexes:)
  regexes.each do |regex|
    expect(result).to match(regex)
  end
end

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      if fact('osfamily') == 'Debian'
        # These should be on all Deb-flavor machines by default...
        # But Docker is often more slimline
        shell('apt-get install apt-transport-https software-properties-common -y', acceptable_exit_codes: [0])
      end
      # Bolt requires gcc and make
      install_package(host, 'gcc')
      install_package(host, 'make')
      install_bolt_on(host)
    end
  end
end
