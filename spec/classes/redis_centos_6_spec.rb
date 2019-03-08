require 'spec_helper'

describe 'redis' do
  context 'on CentOS 6' do
    let(:facts) do
      centos_6_facts
    end

    context 'should set CentOS specific values' do
      context 'when $::redis_server_version fact is not present and package_ensure is a newer version(3.2.1) (older features enabled)' do
        let(:facts) do
          centos_6_facts.merge(redis_server_version: nil,
                               puppetversion: Puppet.version)
        end
        let(:params) { { package_ensure: '3.2.1' } }

        it { is_expected.to contain_file('/etc/redis.conf.puppet').without('content' => %r{^hash-max-zipmap-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
      end

      context 'when $::redis_server_version fact is not present and package_ensure is a newer version(4.0-rc3) (older features enabled)' do
        let(:facts) do
          centos_6_facts.merge(redis_server_version: nil,
                               puppetversion: Puppet.version)
        end
        let(:params) { { package_ensure: '4.0-rc3' } }

        it { is_expected.to contain_file('/etc/redis.conf.puppet').without('content' => %r{^hash-max-zipmap-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').without('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
      end

      context 'when $::redis_server_version fact is present but the older version (older features not enabled)' do
        let(:facts) do
          centos_6_facts.merge(redis_server_version: '2.4.10',
                               puppetversion: Puppet.version)
        end

        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^hash-max-zipmap-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').without('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').without('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').without('content' => %r{^tcp-backlog}) }
      end

      context 'when $::redis_server_version fact is present but a newer version (older features enabled)' do
        let(:facts) do
          centos_6_facts.merge(redis_server_version: '3.2.1',
                               puppetversion: Puppet.version)
        end

        it { is_expected.to contain_file('/etc/redis.conf.puppet').without('content' => %r{^hash-max-zipmap-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
      end
    end
  end
end
