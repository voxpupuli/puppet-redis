# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis', if: %w[centos redhat].include?(os[:family]) && os[:release].to_i == 7 do
  before(:all) do
    apply_manifest_on(hosts, 'service{"redis" : ensure => stopped, enable => false}')
  end

  after(:all) do
    apply_manifest('service{"rh-redis5-redis" : ensure => stopped, enable => false}')
  end

  include_examples 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'redis::globals':
        scl => 'rh-redis5',
      }
      class { 'redis':
        manage_repo => true,
      }
      PUPPET
    end
  end

  specify { expect(package('rh-redis5-redis')).to be_installed }
  specify { expect(service('rh-redis5-redis')).to be_running.and be_enabled }

  it 'redis should respond to ping command' do
    expect(command('scl enable rh-redis5 -- redis-cli ping')).
      to have_attributes(stdout: %r{PONG})
  end
end
