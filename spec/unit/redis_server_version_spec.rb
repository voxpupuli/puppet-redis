require 'spec_helper'

describe 'redis_server_version', type: :fact do
  before { Facter.clear }
  after { Facter.clear }

  it 'is 3.2.9 according to output' do
    Facter::Util::Resolution.stubs(:which).with('redis-server').returns('/usr/bin/redis-server')
    redis_server_3209_version = "Redis server v=3.2.9 sha=00000000:0 malloc=jemalloc-4.0.3 bits=64 build=67e0f9d6580364c0\n"
    Facter::Util::Resolution.stubs(:exec).with('redis-server -v').returns(redis_server_3209_version)
    expect(Facter.fact(:redis_server_version).value).to eq('3.2.9')
  end

  it 'is empty string if redis-server not installed' do
    Facter::Util::Resolution.stubs(:which).with('redis-server').returns(nil)
    expect(Facter.fact(:redis_server_version).value).to eq(nil)
  end
end
