# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis::sentinel' do
  redis_name = fact('os.family') == 'Debian' ? 'redis-server' : 'redis'

  include_examples 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'redis::sentinel':
        master_name      => 'mymaster',
        redis_host       => '127.0.0.1',
        failover_timeout => 10000,
      }
      PUPPET
    end
  end

  specify { expect(package(redis_name)).to be_installed }
  specify { expect(service(redis_name)).to be_running }

  specify 'redis should respond to ping command' do
    expect(command('redis-cli ping')).
      to have_attributes(stdout: %r{PONG})
  end

  specify { expect(service('redis-sentinel')).to be_running }

  if redis_name == 'redis-server'
    specify { expect(package('redis-sentinel')).to be_installed }
  else
    specify { expect(package('redis-sentinel')).not_to be_installed }
  end

  specify 'redis-sentinel should return correct sentinel master' do
    expect(command('redis-cli -p 26379 SENTINEL masters')).
      to have_attributes(stdout: %r{^mymaster})
  end
end
