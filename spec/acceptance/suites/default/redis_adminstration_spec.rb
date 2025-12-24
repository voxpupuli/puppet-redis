# frozen_string_literal: true

require 'spec_helper_acceptance'

RSpec::Matchers.define_negated_matcher :execute_without_warning, :execute_with_warning

# systcl settings are untestable in docker
describe 'redis::administration', unless: default['hypervisor'] =~ %r{docker} do
  redis = case fact('os.family')
          when 'RedHat'
            fact('os.release.major').to_i > 9 ? 'valkey' : 'redis'
          else
            'redis'
          end

  def execute_with_warning
    have_attributes(stderr: %r{WARNING})
  end

  include_examples 'an idempotent resource' do
    let(:manifest) { 'include redis, redis::administration' }
  end

  specify do
    expect(file('/proc/sys/vm/overcommit_memory')).
      to have_attributes(content: "1\n")
  end

  specify do
    expect(file('/proc/sys/net/core/somaxconn')).
      to have_attributes(content: "65535\n")
  end

  specify do
    expect(command("timeout 1s #{redis}-server --port 7777 --loglevel verbose")).
      to execute_without_warning.
      and have_attributes(exit_status: 124)
  end
end
