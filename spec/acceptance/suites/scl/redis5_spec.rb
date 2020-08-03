require 'spec_helper_acceptance'

describe 'redis', if: %w[centos redhat].include?(os[:family]) && os[:release].to_i == 7 do
  before(:all) do
    on hosts, puppet_resource('service', 'redis', 'ensure=stopped', 'enable=false')
  end

  after(:all) do
    on hosts, puppet_resource('service', 'rh-redis5-redis', 'ensure=stopped', 'enable=false')
  end

  it 'runs successfully' do
    pp = <<-PUPPET
      class { 'redis::globals':
        scl => 'rh-redis5',
      }
      class { 'redis':
        manage_repo => true,
      }
    PUPPET

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe package('rh-redis5-redis') do
    it { is_expected.to be_installed }
  end

  describe service('rh-redis5-redis') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  context 'redis should respond to ping command' do
    describe command('scl enable rh-redis5 -- redis-cli ping') do
      its(:stdout) { is_expected.to match %r{PONG} }
    end
  end
end
