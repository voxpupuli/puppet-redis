require 'spec_helper'

describe 'redis::instance', type: :define do
  let :pre_condition do
    'class { "redis":
      default_install => false,
    }'
  end
  let :title do
    'app2'
  end
  let(:service_name) { redis_service_name(service_name: title) }
  let(:service_file) { redis_service_file(service_name: service_name, service_provider: facts[:service_provider]) }

  describe 'os-dependent items' do
    context 'on Ubuntu systems' do
      context '14.04' do
        let(:facts) do
          ubuntu_1404_facts
        end

        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^bind 127.0.0.1}) }
        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^logfile /var/log/redis/redis-server-app2\.log}) }
        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^dir /var/lib/redis/redis-server-app2}) }
        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^unixsocket /var/run/redis/redis-server-app2\.sock}) }
        it { is_expected.to contain_file('/var/lib/redis/redis-server-app2') }
        it { is_expected.to contain_service('redis-server-app2').with_ensure('running') }
        it { is_expected.to contain_service('redis-server-app2').with_enable('true') }
        it { is_expected.to contain_file('/etc/init.d/redis-server-app2').with_content(%r{DAEMON_ARGS=/etc/redis/redis-server-app2\.conf}) }
        it { is_expected.to contain_file('/etc/init.d/redis-server-app2').with_content(%r{PIDFILE=/var/run/redis/redis-server-app2\.pid}) }

        context 'with default title' do
          let(:title) { 'default' }

          it { is_expected.to contain_file(service_file).with_content(%r{DAEMON_ARGS=/etc/redis/redis.conf}) }
        end
      end
      context '16.04' do
        let(:facts) do
          ubuntu_1604_facts.merge(service_provider: 'systemd')
        end

        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^bind 127.0.0.1}) }
        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^logfile /var/log/redis/redis-server-app2\.log}) }
        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^dir /var/lib/redis/redis-server-app2}) }
        it { is_expected.to contain_file('/etc/redis/redis-server-app2.conf.puppet').with('content' => %r{^unixsocket /var/run/redis/redis-server-app2\.sock}) }
        it { is_expected.to contain_file('/var/lib/redis/redis-server-app2') }
        it { is_expected.to contain_service('redis-server-app2').with_ensure('running') }
        it { is_expected.to contain_service('redis-server-app2').with_enable('true') }
        it { is_expected.to contain_file('/etc/systemd/system/redis-server-app2.service').with_content(%r{ExecStart=/usr/bin/redis-server /etc/redis/redis-server-app2\.conf}) }

        context 'with default title' do
          let(:title) { 'default' }

          it { is_expected.to contain_file(service_file).with_content(%r{ExecStart=/usr/bin/redis-server /etc/redis/redis.conf}) }
        end
      end
    end
    context 'on CentOS systems' do
      context '6' do
        let(:facts) do
          centos_6_facts
        end

        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^bind 127.0.0.1}) }
        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^logfile /var/log/redis/redis-server-app2\.log}) }
        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^dir /var/lib/redis/redis-server-app2}) }
        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^unixsocket /var/run/redis/redis-server-app2\.sock}) }
        it { is_expected.to contain_file('/var/lib/redis/redis-server-app2') }
        it { is_expected.to contain_service('redis-server-app2').with_ensure('running') }
        it { is_expected.to contain_service('redis-server-app2').with_enable('true') }
        it { is_expected.to contain_file('/etc/init.d/redis-server-app2').with_content(%r{REDIS_CONFIG="/etc/redis-server-app2\.conf"}) }
        it { is_expected.to contain_file('/etc/init.d/redis-server-app2').with_content(%r{pidfile="/var/run/redis/redis-server-app2\.pid"}) }

        context 'with default title' do
          let(:title) { 'default' }

          it { is_expected.to contain_file(service_file).with_content(%r{REDIS_CONFIG="/etc/redis.conf"}) }
        end
      end
      context '7' do
        let(:facts) do
          centos_7_facts.merge(service_provider: 'systemd')
        end

        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^bind 127.0.0.1}) }
        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^logfile /var/log/redis/redis-server-app2\.log}) }
        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^dir /var/lib/redis/redis-server-app2}) }
        it { is_expected.to contain_file('/etc/redis-server-app2.conf.puppet').with('content' => %r{^unixsocket /var/run/redis/redis-server-app2\.sock}) }
        it { is_expected.to contain_file('/var/lib/redis/redis-server-app2') }
        it { is_expected.to contain_service('redis-server-app2').with_ensure('running') }
        it { is_expected.to contain_service('redis-server-app2').with_enable('true') }
        it { is_expected.to contain_file('/etc/systemd/system/redis-server-app2.service').with_content(%r{ExecStart=/usr/bin/redis-server /etc/redis-server-app2\.conf}) }

        context 'with default title' do
          let(:title) { 'default' }

          it { is_expected.to contain_file(service_file).with_content(%r{ExecStart=/usr/bin/redis-server /etc/redis.conf}) }
        end
      end
    end
  end
end
