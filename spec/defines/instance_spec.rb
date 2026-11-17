# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe 'redis::instance' do
  let :pre_condition do
    <<-PUPPET
    class { 'redis':
      default_install => false,
    }
    PUPPET
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:redis) do
        case facts['os']['family']
        when 'RedHat'
          (facts['os']['release']['major'].to_i > 9) ? 'valkey' : 'redis'
        else
          'redis'
        end
      end

      context 'with app2 title' do
        let(:title) { 'app2' }
        let(:config_file) do
          case facts['os']['family']
          when 'RedHat'
            if facts['os']['release']['major'].to_i > 8
              "/etc/#{redis}/#{redis}-server-app2.conf"
            else
              "/etc/#{redis}-server-app2.conf"
            end
          when 'FreeBSD'
            '/usr/local/etc/redis-server-app2.conf'
          when 'Debian', 'Archlinux'
            "/etc/#{redis}/#{redis}-server-app2.conf"
          end
        end
        let(:workdir) do
          case facts['os']['family']
          when 'FreeBSD'
            '/var/db/redis/redis-server-app2'
          else
            "/var/lib/#{redis}/#{redis}-server-app2"
          end
        end
        let(:unixsocket) do
          case facts['os']['family']
          when 'FreeBSD'
            '/var/run/redis/server-app2.sock'
          else
            "/var/run/#{redis}-server-app2/#{redis}.sock"
          end
        end
        let(:pidfile) do
          case facts['os']['family']
          when 'FreeBSD'
            '/var/run/redis/server-app2.pid'
          else
            "/var/run/#{redis}-server-app2/#{redis}.pid"
          end
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_file("#{config_file}.puppet")
            .with_content(%r{^bind 127.0.0.1})
            .with_content(%r{^logfile /var/log/#{redis}/#{redis}-server-app2\.log})
            .with_content(%r{^dir #{workdir}})
            .with_content(%r{^unixsocket #{unixsocket}})
            .with_content(%r{^pidfile #{pidfile}})
        end

        it { is_expected.to contain_file(workdir) }

        if os_facts['os']['family'] == 'FreeBSD'
          it do
            is_expected.to contain_file('/etc/rc.conf.d/redis/profile_server-app2')
              .with_ensure('file')
              .with_owner('root')
              .with_group('wheel')
              .with_mode('0644')
              .with_content("redis_profiles=\"${redis_profiles} server-app2\"\n")
          end

          it do
            is_expected.to contain_service('redis-server-app2')
              .with_ensure('running')
              .with_provider('base')
              .with_start('/usr/sbin/service redis onestart server-app2')
              .with_stop('/usr/sbin/service redis onestop server-app2')
              .with_restart('/usr/sbin/service redis onerestart server-app2')
              .with_status('/usr/sbin/service redis onestatus server-app2')
              .without_enable
              .that_requires('File[/etc/rc.conf.d/redis/profile_server-app2]')
          end

          it do
            is_expected.to contain_exec("copy #{config_file}.puppet to #{config_file}")
              .that_notifies('Service[redis-server-app2]')
          end

          it { is_expected.not_to contain_systemd__unit_file('redis-server-app2.service') }
          it { is_expected.not_to contain_systemd__manage_dropin('redis-server-app2-90-limits.conf') }

          context 'with service_ensure stopped' do
            let(:params) { { service_ensure: 'stopped' } }

            it { is_expected.to contain_service('redis-server-app2').with_ensure('stopped') }
          end

          context 'with notify_service false' do
            let(:params) { { notify_service: false } }

            it do
              is_expected.to contain_exec("copy #{config_file}.puppet to #{config_file}")
                .that_comes_before('Service[redis-server-app2]')
            end
          end

          context 'with manage_service_file false' do
            let(:params) { { manage_service_file: false } }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.not_to contain_file('/etc/rc.conf.d/redis/profile_server-app2') }
            it { is_expected.not_to contain_service('redis-server-app2') }
          end

          context 'with custom service_name' do
            let(:params) { { service_name: 'redis-cache' } }

            it do
              is_expected.to contain_file('/usr/local/etc/redis-cache.conf.puppet')
                .with_content(%r{^pidfile /var/run/redis/cache\.pid})
                .with_content(%r{^unixsocket /var/run/redis/cache\.sock})
            end

            it { is_expected.to contain_file('/etc/rc.conf.d/redis/profile_cache').with_content("redis_profiles=\"${redis_profiles} cache\"\n") }
            it { is_expected.to contain_service('redis-cache').with_start('/usr/sbin/service redis onestart cache') }
          end

          context 'with service_name without provider prefix' do
            let(:params) { { service_name: 'cache' } }

            it { is_expected.to compile.and_raise_error(%r{service_name 'cache' must match 'redis-<profile>'}) }
          end

          context 'with service_name containing invalid characters' do
            let(:params) { { service_name: 'redis-ca che' } }

            it { is_expected.to compile.and_raise_error(%r{must match 'redis-<profile>'}) }
          end

          context 'with default_install true' do
            let :pre_condition do
              <<-PUPPET
              class { 'redis':
                default_install => true,
              }
              PUPPET
            end

            it { is_expected.to compile.and_raise_error(%r{additional instances require redis::default_install to be false}) }
          end

          context 'with provider valkey' do
            let :pre_condition do
              <<-PUPPET
              class { 'redis':
                default_install => false,
                provider        => 'valkey',
              }
              PUPPET
            end

            it do
              is_expected.to contain_file('/usr/local/etc/valkey-server-app2.conf.puppet')
                .with_content(%r{^pidfile /var/run/valkey/server-app2\.pid})
            end

            it { is_expected.to contain_file('/etc/rc.conf.d/valkey/profile_server-app2').with_content("valkey_profiles=\"${valkey_profiles} server-app2\"\n") }
            it { is_expected.to contain_service('valkey-server-app2').with_start('/usr/sbin/service valkey onestart server-app2') }
          end
        else
          it do
            is_expected.to contain_file("/etc/systemd/system/#{redis}-server-app2.service")
              .with_content(%r{ExecStart=/usr/bin/#{redis}-server #{config_file}})
          end

          it { is_expected.to contain_service("#{redis}-server-app2.service").with_ensure(true).with_enable(true) }
        end
      end

      context 'with custom options' do
        let(:title) { 'default' }
        let(:params) do
          {
            config_file_orig: '/tmp/myorig.conf',
            custom_options: { 'myoption' => 'avalue', 'anotheroption' => 'anothervalue' },
          }
        end

        it do
          is_expected.to contain_file('/tmp/myorig.conf')
            .with_content(%r{^bind 127.0.0.1})
            .with_content(%r{^myoption avalue})
            .with_content(%r{^anotheroption anothervalue})
        end
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
