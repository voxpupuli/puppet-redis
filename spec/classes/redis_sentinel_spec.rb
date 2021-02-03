require 'spec_helper'

describe 'redis::sentinel' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:config_file_orig) do
        case facts[:osfamily]
        when 'Archlinux'
          '/etc/redis/redis-sentinel.conf.puppet'
        when 'Debian'
          '/etc/redis/redis-sentinel.conf.puppet'
        when 'Suse'
          '/etc/redis/redis-sentinel.conf.puppet'
        when 'FreeBSD'
          '/usr/local/etc/redis-sentinel.conf.puppet'
        when 'RedHat'
          '/etc/redis-sentinel.conf.puppet'
        end
      end

      let(:pidfile) do
        if facts[:operatingsystem] == 'Ubuntu'
          facts[:operatingsystemmajrelease] == '16.04' ? '/var/run/redis/redis-sentinel.pid' : '/var/run/sentinel/redis-sentinel.pid'
        elsif facts[:operatingsystem] == 'Debian'
          facts[:operatingsystemmajrelease] == '9' ? '/var/run/redis/redis-sentinel.pid' : '/run/sentinel/redis-sentinel.pid'
        else
          '/var/run/redis/redis-sentinel.pid'
        end
      end

      let(:protected_mode) do
        facts[:operatingsystem] != 'Ubuntu' || facts[:operatingsystemmajrelease] != '16.04'
      end

      describe 'without parameters' do
        let(:expected_content) do
          <<CONFIG
port 26379
dir #{facts[:osfamily] == 'Debian' ? '/var/lib/redis' : '/tmp'}
daemonize #{facts[:osfamily] == 'RedHat' ? 'no' : 'yes'}
pidfile #{pidfile}
#{protected_mode ? "protected-mode yes\n" : ''}
sentinel monitor mymaster 127.0.0.1 6379 2
sentinel down-after-milliseconds mymaster 30000
sentinel parallel-syncs mymaster 1
sentinel failover-timeout mymaster 180000

loglevel notice
logfile #{facts[:osfamily] == 'Debian' ? '/var/log/redis/redis-sentinel.log' : '/var/log/redis/sentinel.log'}
CONFIG
        end

        it { is_expected.to create_class('redis::sentinel') }

        it {
          is_expected.to contain_file(config_file_orig).
            with_ensure('file').
            with_mode('0644').
            with_owner('redis').
            with_content(expected_content)
        }

        it {
          is_expected.to contain_service('redis-sentinel').
            with_ensure('running').
            with_enable('true')
        }

        if facts[:os]['family'] == 'Debian'
          it { is_expected.to contain_package('redis-sentinel').with_ensure('present') }
        else
          it { is_expected.not_to contain_package('redis-sentinel') }
        end
      end

      describe 'with custom parameters' do
        let(:params) do
          {
            auth_pass: 'password',
            sentinel_bind: '192.0.2.10',
            protected_mode: false,
            master_name: 'cow',
            down_after: 6000,
            working_dir: '/tmp/redis',
            log_file: '/tmp/barn-sentinel.log',
            failover_timeout: 28_000,
            notification_script: '/path/to/bar.sh',
            client_reconfig_script: '/path/to/foo.sh'
          }
        end

        let(:expected_content) do
          <<CONFIG
bind 192.0.2.10
port 26379
dir /tmp/redis
daemonize #{facts[:osfamily] == 'RedHat' ? 'no' : 'yes'}
pidfile #{pidfile}
#{protected_mode ? "protected-mode no\n" : ''}
sentinel monitor cow 127.0.0.1 6379 2
sentinel down-after-milliseconds cow 6000
sentinel parallel-syncs cow 1
sentinel failover-timeout cow 28000
sentinel auth-pass cow password
sentinel notification-script cow /path/to/bar.sh
sentinel client-reconfig-script cow /path/to/foo.sh

loglevel notice
logfile /tmp/barn-sentinel.log
CONFIG
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('redis::sentinel') }
        it { is_expected.to contain_file(config_file_orig).with_content(expected_content) }
      end

      describe 'with array sentinel bind' do
        let(:params) do
          {
            auth_pass: 'password',
            sentinel_bind: ['192.0.2.10', '192.168.1.1'],
            master_name: 'cow',
            down_after: 6000,
            working_dir: '/tmp/redis',
            log_file: '/tmp/barn-sentinel.log',
            failover_timeout: 28_000,
            notification_script: '/path/to/bar.sh',
            client_reconfig_script: '/path/to/foo.sh'
          }
        end

        let(:expected_content) do
          <<CONFIG
bind 192.0.2.10 192.168.1.1
port 26379
dir /tmp/redis
daemonize #{facts[:osfamily] == 'RedHat' ? 'no' : 'yes'}
pidfile #{pidfile}
#{protected_mode ? "protected-mode yes\n" : ''}
sentinel monitor cow 127.0.0.1 6379 2
sentinel down-after-milliseconds cow 6000
sentinel parallel-syncs cow 1
sentinel failover-timeout cow 28000
sentinel auth-pass cow password
sentinel notification-script cow /path/to/bar.sh
sentinel client-reconfig-script cow /path/to/foo.sh

loglevel notice
logfile /tmp/barn-sentinel.log
CONFIG
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('redis::sentinel') }
        it { is_expected.to contain_file(config_file_orig).with_content(expected_content) }
      end

      describe 'with parameter sentinel_bind for redis6 config' do
        let(:params) do
          {
            sentinel_bind: %w[192.168.1.1 127.0.0.1],
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^bind 192.168.1.1 127.0.0.1$}
          )
        }
      end

      describe 'with parameter protected_mode for redis6 config' do
        let(:params) do
          {
            protected_mode: false,
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end
        it do
          if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease] == '16.04'
            is_expected.not_to contain_file(config_file_orig).with_content(%r{^protected-mode$})
          else
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^protected-mode no$}
            )
          end
        end
      end

      describe 'with parameter sentinel_port for redis6 config' do
        let(:params) do
          {
            sentinel_port: 6200,
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^port 6200$}
          )
        }
      end

      describe 'with parameter daemonize for redis6 config' do
        let(:params) do
          {
            daemonize: true,
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^daemonize yes$}
          )
        }
      end

      describe 'with parameter pid_file for redis6 config' do
        let(:params) do
          {
            pid_file: '/var/run/redis6-sentinel.pid',
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^pidfile /var/run/redis6-sentinel.pid$}
          )
        }
      end

      describe 'with parameter log_file for redis6 config' do
        let(:params) do
          {
            log_file: '/tmp/sentinel.log',
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^logfile /tmp/sentinel.log$}
          )
        }
      end

      describe 'with parameter working_dir for redis6 config' do
        let(:params) do
          {
            working_dir: '/tmp/sentinel/',
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^dir /tmp/sentinel/$}
          )
        }
      end

      describe 'test sentinel monitor for redis6 config' do
        let(:params) do
          {
            master_name: 'mymaster',
            redis_host: 'redis01',
            redis_port: 6378,
            quorum: 5,
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^sentinel monitor mymaster redis01 6378 5$}
          )
        }
      end

      describe 'test auth_pass for redis6 config' do
        let(:params) do
          {
            master_name: 'mymaster',
            auth_pass: 'super_secure_secret',
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^sentinel auth-pass mymaster super_secure_secret$}
          )
        }
      end

      describe 'test sentinel down-after-milliseconds for redis6 config' do
        let(:params) do
          {
            master_name: 'mymaster',
            down_after: 17000,
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^sentinel down-after-milliseconds mymaster 17000$}
          )
        }
      end

      describe 'test sentinel failover-timeout for redis6 config' do
        let(:params) do
          {
            master_name: 'mymaster',
            failover_timeout: 17001,
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^sentinel failover-timeout mymaster 17001$}
          )
        }
      end

      describe 'test sentinel notification-script for redis6 config' do
        let(:params) do
          {
            master_name: 'mymaster',
            notification_script: '/var/redis6/notify.sh',
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^sentinel notification-script mymaster /var/redis6/notify.sh$}
          )
        }
      end

      describe 'test sentinel client-reconfig-script for redis6 config' do
        let(:params) do
          {
            master_name: 'mymaster',
            client_reconfig_script: '/var/redis6/reconfig.sh',
            conf_template: "redis/redis6-sentinel.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^sentinel client-reconfig-script mymaster /var/redis6/reconfig.sh$}
          )
        }
      end

    end
  end
end
