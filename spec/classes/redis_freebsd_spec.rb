require 'spec_helper'

describe 'redis' do
  context 'on FreeBSD' do
    let(:facts) do
      freebsd_facts
    end

    context 'should set FreeBSD specific values' do
      it { is_expected.to contain_file('/usr/local/etc/redis.conf.puppet').with('content' => %r{dir /var/db/redis}) }
      it { is_expected.to contain_file('/usr/local/etc/redis.conf.puppet').with('content' => %r{pidfile /var/run/redis/redis\.pid}) }
    end
  end
end
