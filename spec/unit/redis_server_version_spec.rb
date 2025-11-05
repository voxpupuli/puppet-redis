# frozen_string_literal: true

require 'spec_helper'

describe 'redis_server_version', type: :fact do
  before { Facter.clear }

  after { Facter.clear }

  it 'is 3.2.9 according to output (redis)' do
    allow(Facter::Util::Resolution).to receive(:which).with('redis-server').and_return('/usr/bin/redis-server')
    allow(Facter::Util::Resolution).to receive(:which).with('valkey-server').and_return(nil)
    redis_server_3209_version = "Redis server v=3.2.9 sha=00000000:0 malloc=jemalloc-4.0.3 bits=64 build=67e0f9d6580364c0\n"
    allow(Facter::Util::Resolution).to receive(:exec).with('redis-server -v').and_return(redis_server_3209_version)
    expect(Facter.fact(:redis_server_version).value).to eq('3.2.9')
  end

  it 'is 3.2.9 according to output (valkey)' do
    allow(Facter::Util::Resolution).to receive(:which).with('redis-server').and_return(nil)
    allow(Facter::Util::Resolution).to receive(:which).with('valkey-server').and_return('/usr/bin/redis-server')
    redis_server_3209_version = "Valkey server v=3.2.9 sha=00000000:0 malloc=jemalloc-4.0.3 bits=64 build=67e0f9d6580364c0\n"
    allow(Facter::Util::Resolution).to receive(:exec).with('valkey-server -v').and_return(redis_server_3209_version)
    expect(Facter.fact(:redis_server_version).value).to eq('3.2.9')
  end

  it 'is empty string if redis-server not installed' do
    allow(Facter::Util::Resolution).to receive(:which).with('redis-server').and_return(nil)
    allow(Facter::Util::Resolution).to receive(:which).with('valkey-server').and_return(nil)
    expect(Facter.fact(:redis_server_version).value).to eq(nil)
  end
end
