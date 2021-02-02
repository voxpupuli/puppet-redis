require 'spec_helper'

describe 'Redis::MemoryPolicy' do
  it { is_expected.to allow_values('volatile-lru', 'allkeys-lru', 'volatile-lfu', 'allkeys-lfu', 'volatile-random', 'allkeys-random', 'volatile-ttl', 'noeviction') }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value('') }
end
