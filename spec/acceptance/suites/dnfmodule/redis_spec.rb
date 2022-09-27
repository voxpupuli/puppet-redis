# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis', if: %w[centos redhat].include?(os[:family]) && os[:release].to_i == 8 do
  redis_name = 'redis'

  it 'runs successfully' do
    pp = <<-PUPPET
      class { 'redis':
        dnf_module_stream => '6',
        package_ensure    => 'latest',
      }
    PUPPET

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe package(redis_name) do
    it { is_expected.to be_installed }
  end

  describe service(redis_name) do
    it { is_expected.to be_running }
  end

  context 'redis should respond to ping command' do
    describe command('redis-cli ping') do
      its(:stdout) { is_expected.to match %r{PONG} }
    end
  end

  describe command('redis-server -v') do
    its(:stdout) { is_expected.to match %r{v=6.+} }
  end
end
