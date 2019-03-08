require 'spec_helper'

describe 'redis' do
  context 'on Ubuntu 1404' do
    let(:facts) do
      ubuntu_1404_facts
    end

    context 'should set Ubuntu specific values' do
      context 'when $::redis_server_version fact is not present (older features not enabled)' do
        let(:facts) do
          ubuntu_1404_facts.merge(redis_server_version: nil)
        end

        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').without('content' => %r{^tcp-backlog}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').without('content' => %r{^protected-mode}) }
      end

      context 'when $::redis_server_version fact is not present and package_ensure is a newer version(3.2.1) (older features enabled)' do
        let(:facts) do
          ubuntu_1404_facts.merge(redis_server_version: nil)
        end
        let(:params) { { package_ensure: '3.2.1' } }

        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
      end

      context 'when $::redis_server_version fact is not present and package_ensure is a newer version(3:3.2.1) (older features enabled)' do
        let(:facts) do
          ubuntu_1404_facts.merge(redis_server_version: nil)
        end
        let(:params) { { package_ensure: '3:3.2.1' } }

        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
      end

      context 'when $::redis_server_version fact is not present and package_ensure is a newer version(4:4.0-rc3) (older features enabled)' do
        let(:facts) do
          ubuntu_1404_facts.merge(redis_server_version: nil)
        end
        let(:params) { { package_ensure: '4:4.0-rc3' } }

        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').without('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
      end
      context 'when $::redis_server_version fact is not present and package_ensure is a newer version(4.0-rc3) (older features enabled)' do
        let(:facts) do
          ubuntu_1404_facts.merge(redis_server_version: nil)
        end
        let(:params) { { package_ensure: '4.0-rc3' } }

        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').without('content' => %r{^protected-mode}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
      end

      context 'when $::redis_server_version fact is present but the older version (older features not enabled)' do
        let(:facts) do
          ubuntu_1404_facts.merge(redis_server_version: '2.8.4')
        end

        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').without('content' => %r{^tcp-backlog}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').without('content' => %r{^protected-mode}) }
      end

      context 'when $::redis_server_version fact is present but a newer version (older features enabled)' do
        let(:facts) do
          ubuntu_1404_facts.merge(redis_server_version: '3.2.1')
        end

        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^hash-max-ziplist-entries}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^tcp-backlog}) }
        it { is_expected.to contain_file('/etc/redis/redis.conf.puppet').with('content' => %r{^protected-mode}) }
      end
    end
  end
end
