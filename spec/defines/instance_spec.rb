require 'spec_helper'

describe 'redis::instance' do
  let :pre_condition do
    <<-PUPPET
    class { 'redis':
      default_install => false,
    }
    PUPPET
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with app2 title' do
        let(:title) { 'app2' }
        let(:config_file) do
          case facts[:osfamily]
          when 'RedHat'
            '/etc/redis-server-app2.conf'
          when 'FreeBSD'
            '/usr/local/etc/redis/redis-server-app2.conf'
          when 'Debian'
            '/etc/redis/redis-server-app2.conf'
          when 'Archlinux'
            '/etc/redis/redis-server-app2.conf'
          end
        end

        it do
          is_expected.to contain_file("#{config_file}.puppet").
            with_content(%r{^bind 127.0.0.1}).
            with_content(%r{^logfile /var/log/redis/redis-server-app2\.log}).
            with_content(%r{^dir /var/lib/redis/redis-server-app2}).
            with_content(%r{^unixsocket /var/run/redis/redis-server-app2\.sock})
        end
        it { is_expected.to contain_file('/var/lib/redis/redis-server-app2') }

        it do
          if facts['service_provider'] == 'systemd'
            is_expected.to contain_file('/etc/systemd/system/redis-server-app2.service').with_content(%r{ExecStart=/usr/bin/redis-server #{config_file}})
          else
            case facts[:os]['family']
            when 'Debian'
              is_expected.to contain_file('/etc/init.d/redis-server-app2').
                with_content(%r{DAEMON_ARGS=#{config_file}}).
                with_content(%r{PIDFILE=/var/run/redis/redis-server-app2\.pid})
            when 'RedHat'
              is_expected.to contain_file('/etc/init.d/redis-server-app2').
                with_content(%r{REDIS_CONFIG="#{config_file}"}).
                with_content(%r{pidfile="/var/run/redis/redis-server-app2\.pid"})
            else
              is_expected.to contain_file('/etc/init.d/redis-server-app2')
            end
          end
        end

        it { is_expected.to contain_service('redis-server-app2').with_ensure('running').with_enable('true') }
      end
    end
  end
end
