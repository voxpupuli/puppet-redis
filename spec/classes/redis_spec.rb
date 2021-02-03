require 'spec_helper'

describe 'redis' do
  let(:service_file) { "/etc/systemd/system/#{service_name}.service" }
  let(:package_name) { manifest_vars[:package_name] }
  let(:service_name) { manifest_vars[:service_name] }
  let(:config_file) { manifest_vars[:config_file] }
  let(:config_file_orig) { manifest_vars[:config_file_orig] }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease] == '16.04'
        let(:systemd) { '' }
        let(:servicetype) { 'forking' }
      else
        let(:systemd) { ' --supervised systemd' }
        let(:servicetype) { 'notify' }
      end

      describe 'without parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('redis') }
        it { is_expected.to contain_class('redis::preinstall') }
        it { is_expected.to contain_class('redis::install') }
        it { is_expected.to contain_class('redis::config') }
        it { is_expected.to contain_class('redis::service') }

        it { is_expected.to contain_package(package_name).with_ensure('present') }

        it do
          is_expected.to contain_file(config_file_orig).
            with_ensure('file').
            with_content(%r{logfile /var/log/redis/redis\.log}).
            without_content(%r{undef})

          if facts[:osfamily] == 'FreeBSD'
            is_expected.to contain_file(config_file_orig).
              with_content(%r{dir /var/db/redis}).
              with_content(%r{pidfile /var/run/redis/redis\.pid})
          end
        end

        it do
          is_expected.to contain_service(service_name).with(
            'ensure'     => 'running',
            'enable'     => 'true',
          )
        end

        context 'with SCL', if: facts[:osfamily] == 'RedHat' && facts[:operatingsystemmajrelease] < '8' do
          let(:pre_condition) do
            <<-PUPPET
            class { 'redis::globals':
              scl => 'rh-redis5',
            }
            PUPPET
          end

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to create_class('redis').
              with_package_name('rh-redis5-redis').
              with_config_file('/etc/opt/rh/rh-redis5/redis.conf').
              with_service_name('rh-redis5-redis')
          end

          context 'manage_repo => true', if: facts[:operatingsystem] == 'CentOS' do
            let(:params) { { manage_repo: true } }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_package('centos-release-scl-rh') }
          end
        end
      end

      context 'with managed_by_cluster_manager true' do
        let(:params) { { managed_by_cluster_manager: true } }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file('/etc/security/limits.d/redis.conf').with(
            'ensure'  => 'file',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'content' => "redis soft nofile 65536\nredis hard nofile 65536\n"
          )
        end

        context 'when not managing service' do
          let(:params) { super().merge(service_manage: false, notify_service: false) }

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file('/etc/security/limits.d/redis.conf').with(
              'ensure' => 'file',
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0644',
              'content' => "redis soft nofile 65536\nredis hard nofile 65536\n"
            )
          end
        end
      end

      context 'with ulimit' do
        let(:params) { { ulimit: 7777 } }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_file("/etc/systemd/system/#{service_name}.service.d/limit.conf").
            with_ensure('file').
            with_owner('root').
            with_group('root').
            with_mode('0444')
          # Only necessary for Puppet < 6.1.0,
          # See https://github.com/puppetlabs/puppet/commit/f8d5c60ddb130c6429ff12736bfdb4ae669a9fd4
          if Puppet.version < '6.1'
            is_expected.to contain_augeas('Systemd redis ulimit').
              with_incl("/etc/systemd/system/#{service_name}.service.d/limit.conf").
              with_lens('Systemd.lns').
              with_changes(['defnode nofile Service/LimitNOFILE ""', 'set $nofile/value "7777"']).
              that_notifies('Class[systemd::systemctl::daemon_reload]')
          else
            is_expected.to contain_augeas('Systemd redis ulimit').
              with_incl("/etc/systemd/system/#{service_name}.service.d/limit.conf").
              with_lens('Systemd.lns').
              with_changes(['defnode nofile Service/LimitNOFILE ""', 'set $nofile/value "7777"'])
          end
        end
      end

      describe 'with parameter activerehashing' do
        let(:params) do
          {
            activerehashing: true
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{activerehashing.*yes}) }
      end

      describe 'with parameter aof_load_truncated' do
        let(:params) do
          {
            aof_load_truncated: true
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{aof-load-truncated.*yes}) }
      end

      describe 'with parameter aof_rewrite_incremental_fsync' do
        let(:params) do
          {
            aof_rewrite_incremental_fsync: true
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{aof-rewrite-incremental-fsync.*yes}) }
      end

      describe 'with parameter appendfilename' do
        let(:params) do
          {
            appendfilename: '_VALUE_'
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{appendfilename.*_VALUE_}) }
      end

      describe 'with parameter appendfsync' do
        let(:params) do
          {
            appendfsync: 'no'
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{^appendfsync no$}) }
      end

      describe 'with parameter appendonly' do
        let(:params) do
          {
            appendonly: true
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{appendonly.*yes}) }
      end

      describe 'with parameter auto_aof_rewrite_min_size' do
        let(:params) do
          {
            auto_aof_rewrite_min_size: '_VALUE_'
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{auto-aof-rewrite-min-size.*_VALUE_}) }
      end

      describe 'with parameter auto_aof_rewrite_percentage' do
        let(:params) do
          {
            auto_aof_rewrite_percentage: 75
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{auto-aof-rewrite-percentage 75}) }
      end

      describe 'parameter bind' do
        context 'by default' do
          it 'binds to localhost' do
            is_expected.to contain_file(config_file_orig).with_content(%r{bind 127\.0\.0\.1$})
          end
        end
        context 'with a single IP address' do
          let(:params) { { bind: '10.0.0.1' } }

          it { is_expected.to contain_file(config_file_orig).with_content(%r{bind 10\.0\.0\.1$}) }
        end
        context 'with array of IP addresses' do
          let(:params) do
            {
              bind: ['127.0.0.1', '::1']
            }
          end

          it { is_expected.to contain_file(config_file_orig).with_content(%r{bind 127\.0\.0\.1 ::1}) }
        end
        context 'with empty array' do
          let(:params) { { bind: [] } }

          it { is_expected.not_to contain_file(config_file_orig).with_content(%r{^bind}) }
        end
      end

      describe 'with parameter output_buffer_limit_slave' do
        let(:params) do
          {
            output_buffer_limit_slave: '_VALUE_'
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{client-output-buffer-limit slave.*_VALUE_}) }
      end

      describe 'with parameter output_buffer_limit_pubsub' do
        let(:params) do
          {
            output_buffer_limit_pubsub: '_VALUE_'
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{client-output-buffer-limit pubsub.*_VALUE_}) }
      end

      describe 'with parameter: config_dir' do
        let(:params) { { config_dir: '/etc/config_dir' } }

        it { is_expected.to contain_file('/etc/config_dir').with_ensure('directory') }
      end

      describe 'with parameter: config_dir_mode' do
        let(:params) { { config_dir_mode: '0700' } }

        it { is_expected.to contain_file('/etc/redis').with_mode('0700') }
      end

      describe 'with parameter: log_dir_mode' do
        let(:params) { { log_dir_mode: '0660' } }

        it { is_expected.to contain_file('/var/log/redis').with_mode('0660') }
      end

      describe 'with parameter: config_file_orig' do
        let(:params) { { config_file_orig: '/path/to/orig' } }

        it { is_expected.to contain_file('/path/to/orig') }
      end

      describe 'with parameter: config_file_mode' do
        let(:params) { { config_file_mode: '0600' } }

        it { is_expected.to contain_file(config_file_orig).with_mode('0600') }
      end

      describe 'with parameter: config_group' do
        let(:params) { { config_group: '_VALUE_' } }

        it { is_expected.to contain_file('/etc/redis').with_group('_VALUE_') }
      end

      describe 'with parameter: config_owner' do
        let(:params) { { config_owner: '_VALUE_' } }

        it { is_expected.to contain_file('/etc/redis').with_owner('_VALUE_') }
      end

      describe 'with parameter daemonize' do
        let(:params) do
          {
            daemonize: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{daemonize.*yes}
          )
        }
      end

      describe 'with parameter databases' do
        let(:params) do
          {
            databases: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{databases 42}
          )
        }
      end

      describe 'with parameter dbfilename' do
        let(:params) do
          {
            dbfilename: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{dbfilename.*_VALUE_}
          )
        }
      end

      describe 'without parameter dbfilename' do
        let(:params) do
          {
            dbfilename: false
          }
        end

        it { is_expected.to contain_file(config_file_orig).without_content(%r{^dbfilename}) }
      end

      describe 'with parameter hash_max_ziplist_entries' do
        let(:params) do
          {
            hash_max_ziplist_entries: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{hash-max-ziplist-entries 42}
          )
        }
      end

      describe 'with parameter hash_max_ziplist_value' do
        let(:params) do
          {
            hash_max_ziplist_value: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{hash-max-ziplist-value 42}
          )
        }
      end

      # TODO: Only present in 3.0
      describe 'with parameter list_max_ziplist_entries' do
        let(:params) do
          {
            list_max_ziplist_entries: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{list-max-ziplist-entries 42}
          )
        }
      end

      describe 'with parameter list_max_ziplist_value' do
        let(:params) do
          {
            list_max_ziplist_value: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{list-max-ziplist-value 42}
          )
        }
      end

      describe 'with parameter log_dir' do
        let(:params) do
          {
            log_dir: '/var/log/redis'
          }
        end

        it {
          is_expected.to contain_file('/var/log/redis').with(
            'ensure' => 'directory'
          )
        }
      end

      describe 'with parameter log_file' do
        describe 'as absolute path' do
          let(:params) do
            {
              log_file: '/var/log/my-redis/my-redis.log'
            }
          end

          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^logfile /var/log/my-redis/my-redis\.log$}
            )
          }
        end

        describe 'as relative path' do
          let(:params) do
            {
              log_dir: '/var/log/my-redis',
              log_file: 'my-redis.log'
            }
          end

          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^logfile /var/log/my-redis/my-redis\.log$}
            )
          }
        end
      end

      describe 'with parameter log_level' do
        let(:params) do
          {
            log_level: 'debug'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^loglevel debug$}
          )
        }
      end

      describe 'with parameter: manage_repo' do
        let(:params) { { manage_repo: true } }

        case facts[:operatingsystem]
        when 'Ubuntu'
          it { is_expected.to contain_apt__ppa('ppa:chris-lea/redis-server') }
        when 'RedHat', 'CentOS', 'Scientific', 'OEL', 'Amazon'
          it { is_expected.to contain_class('epel') }
        end
      end

      describe 'with parameter unixsocket' do
        describe '/tmp/redis.sock' do
          let(:params) { { unixsocket: '/tmp/redis.sock' } }

          it { is_expected.to contain_file(config_file_orig).with_content(%r{^unixsocket /tmp/redis\.sock$}) }
        end
      end

      describe 'with parameter unixsocketperm' do
        describe '777' do
          let(:params) { { unixsocketperm: '777' } }

          it { is_expected.to contain_file(config_file_orig).with_content(%r{^unixsocketperm 777$}) }
        end
      end

      describe 'with parameter masterauth' do
        let(:params) do
          {
            masterauth: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{masterauth.*_VALUE_}
          )
        }
      end

      describe 'with parameter maxclients' do
        let(:params) do
          {
            maxclients: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^maxclients 42$}
          )
        }
      end

      describe 'with parameter maxmemory' do
        let(:params) do
          {
            maxmemory: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{maxmemory.*_VALUE_}
          )
        }
      end

      describe 'with parameter maxmemory_policy' do
        let(:params) do
          {
            maxmemory_policy: 'noeviction'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{maxmemory-policy.*noeviction}
          )
        }
      end

      describe 'with parameter maxmemory_samples' do
        let(:params) do
          {
            maxmemory_samples: 9
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{maxmemory-samples.*9}
          )
        }
      end

      describe 'with parameter min_slaves_max_lag' do
        let(:params) do
          {
            min_slaves_max_lag: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^min-slaves-max-lag 42$}
          )
        }
      end

      describe 'with parameter min_slaves_to_write' do
        let(:params) do
          {
            min_slaves_to_write: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^min-slaves-to-write 42$}
          )
        }
      end

      describe 'with parameter notify_keyspace_events' do
        let(:params) do
          {
            notify_keyspace_events: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{notify-keyspace-events.*_VALUE_}
          )
        }
      end

      describe 'with parameter notify_service' do
        let(:params) do
          {
            notify_service: true
          }
        end

        it { is_expected.to contain_file(config_file_orig).that_notifies("Service[#{service_name}]") }
      end

      describe 'with parameter no_appendfsync_on_rewrite' do
        let(:params) do
          {
            no_appendfsync_on_rewrite: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{no-appendfsync-on-rewrite.*yes}
          )
        }
      end

      describe 'with parameter: package_ensure' do
        let(:params) { { package_ensure: '_VALUE_' } }

        it {
          is_expected.to contain_package(package_name).with(
            'ensure' => '_VALUE_'
          )
        }
      end

      describe 'with parameter: package_name' do
        let(:params) { { package_name: '_VALUE_' } }

        it { is_expected.to contain_package('_VALUE_') }
      end

      describe 'with parameter pid_file' do
        let(:params) do
          {
            pid_file: '/path/to/redis.pid'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^pidfile /path/to/redis.pid$}
          )
        }
      end

      describe 'with parameter port' do
        let(:params) do
          {
            port: 6666
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^port 6666$}
          )
        }
      end

      describe 'with parameter protected-mode' do
        let(:params) do
          {
            protected_mode: false
          }
        end

        it do
          if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease] == '16.04'
            is_expected.not_to contain_file(config_file_orig).with_content(%r{^protected-mode$})
          else
            is_expected.to contain_file(config_file_orig).with_content(%r{^protected-mode no$})
          end
        end
      end

      describe 'with parameter hll_sparse_max_bytes' do
        let(:params) do
          {
            hll_sparse_max_bytes: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^hll-sparse-max-bytes 42$}
          )
        }
      end

      describe 'with parameter hz' do
        let(:params) do
          {
            hz: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^hz 42$}
          )
        }
      end

      describe 'with parameter latency_monitor_threshold' do
        let(:params) do
          {
            latency_monitor_threshold: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^latency-monitor-threshold 42$}
          )
        }
      end

      describe 'with parameter rdbcompression' do
        let(:params) do
          {
            rdbcompression: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{rdbcompression.*yes}
          )
        }
      end

      describe 'with parameter rename_commands' do
        context 'with a single rename' do
          let(:params) do
            {
              rename_commands: { CONFIG: "\"\"" }
            }
          end
          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^rename-command CONFIG ""$}
            )
          }
        end
        context 'with multiple renames' do
          let(:params) do
            {
              rename_commands: { CONFIG: "\"\"", RENAME: "\"\"" }
            }
          end
          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^rename-command CONFIG ""$}
            )
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^rename-command RENAME ""$}
            )
          }
        end
        context 'with empty hash' do
          let(:params) do
            {
              "rename_commands" => {}
            }
          end
          it { is_expected.not_to contain_file(config_file_orig).with_content(%r{^rename-command}) }
        end
      end

      describe 'with parameter repl_backlog_size' do
        let(:params) do
          {
            repl_backlog_size: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{repl-backlog-size.*_VALUE_}
          )
        }
      end

      describe 'with parameter repl_backlog_ttl' do
        let(:params) do
          {
            repl_backlog_ttl: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-backlog-ttl 42$}
          )
        }
      end

      describe 'with parameter repl_disable_tcp_nodelay' do
        let(:params) do
          {
            repl_disable_tcp_nodelay: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{repl-disable-tcp-nodelay.*yes}
          )
        }
      end

      describe 'with parameter repl_ping_slave_period' do
        let(:params) do
          {
            repl_ping_slave_period: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-ping-slave-period 42}
          )
        }
      end

      describe 'with parameter repl_timeout' do
        let(:params) do
          {
            repl_timeout: 1
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{repl-timeout.*1}
          )
        }
      end

      describe 'with parameter requirepass' do
        let(:params) do
          {
            requirepass: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{requirepass.*_VALUE_}
          )
        }
      end

      describe 'with parameter save_db_to_disk' do
        context 'true' do
          let(:params) do
            {
              save_db_to_disk: true
            }
          end

          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^save}
            )
          }
        end

        context 'false' do
          let(:params) do
            {
              save_db_to_disk: false
            }
          end

          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^(?!save)}
            )
          }
        end
      end

      describe 'with parameter save_db_to_disk_interval' do
        context 'with save_db_to_disk true' do
          context 'default' do
            let(:params) do
              {
                save_db_to_disk: true
              }
            end

            it { is_expected.to contain_file(config_file_orig).with('content' => %r{save 900 1}) }
            it { is_expected.to contain_file(config_file_orig).with('content' => %r{save 300 10}) }
            it {
              is_expected.to contain_file(config_file_orig).with('content' => %r{save 60 10000})
            }
          end

          context 'default' do
            let(:params) do
              {
                save_db_to_disk: true,
                save_db_to_disk_interval: { '900' => '2', '300' => '11', '60' => '10011' }
              }
            end

            it { is_expected.to contain_file(config_file_orig).with('content' => %r{save 900 2}) }
            it { is_expected.to contain_file(config_file_orig).with('content' => %r{save 300 11}) }
            it {
              is_expected.to contain_file(config_file_orig).with('content' => %r{save 60 10011})
            }
          end
        end

        context 'with save_db_to_disk false' do
          context 'default' do
            let(:params) do
              {
                save_db_to_disk: false
              }
            end

            it { is_expected.to contain_file(config_file_orig).without('content' => %r{save 900 1}) }
            it { is_expected.to contain_file(config_file_orig).without('content' => %r{save 300 10}) }
            it { is_expected.to contain_file(config_file_orig).without('content' => %r{save 60 10000}) }
          end
        end
      end

      describe 'with parameter: service_manage (set to false)' do
        let(:params) { { service_manage: false } }

        it { is_expected.not_to contain_service(package_name) }
      end

      describe 'with parameter: service_enable' do
        let(:params) { { service_enable: true } }

        it { is_expected.to contain_service(package_name).with_enable(true) }
      end

      describe 'with parameter: service_ensure' do
        let(:params) { { service_ensure: 'stopped' } }

        it { is_expected.to contain_service(package_name).with_ensure('stopped') }
      end

      describe 'with parameter: service_group' do
        let(:params) { { service_group: '_VALUE_' } }

        it { is_expected.to contain_file('/var/log/redis').with_group('_VALUE_') }
      end

      describe 'with parameter: service_name' do
        let(:params) { { service_name: '_VALUE_' } }

        it { is_expected.to contain_service('_VALUE_').with_name('_VALUE_') }
      end

      describe 'with parameter: service_user' do
        let(:params) { { service_user: '_VALUE_' } }

        it { is_expected.to contain_file('/var/log/redis').with_owner('_VALUE_') }
      end

      describe 'with parameter set_max_intset_entries' do
        let(:params) do
          {
            set_max_intset_entries: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^set-max-intset-entries 42$}
          )
        }
      end

      describe 'with parameter slave_priority' do
        let(:params) do
          {
            slave_priority: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^slave-priority 42$}
          )
        }
      end

      describe 'with parameter slave_read_only' do
        let(:params) do
          {
            slave_read_only: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{slave-read-only.*yes}
          )
        }
      end

      describe 'with parameter slave_serve_stale_data' do
        let(:params) do
          {
            slave_serve_stale_data: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{slave-serve-stale-data.*yes}
          )
        }
      end

      describe 'with parameter: slaveof' do
        context 'binding to localhost' do
          let(:params) do
            {
              bind: '127.0.0.1',
              slaveof: '_VALUE_'
            }
          end

          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^slaveof _VALUE_}
            )
          }
        end

        context 'binding to external ip' do
          let(:params) do
            {
              bind: '10.0.0.1',
              slaveof: '_VALUE_'
            }
          end

          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^slaveof _VALUE_}
            )
          }
        end
      end

      describe 'with parameter slowlog_log_slower_than' do
        let(:params) do
          {
            slowlog_log_slower_than: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^slowlog-log-slower-than 42$}
          )
        }
      end

      describe 'with parameter slowlog_max_len' do
        let(:params) do
          {
            slowlog_max_len: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^slowlog-max-len 42$}
          )
        }
      end

      describe 'with parameter stop_writes_on_bgsave_error' do
        let(:params) do
          {
            stop_writes_on_bgsave_error: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{stop-writes-on-bgsave-error.*yes}
          )
        }
      end

      describe 'with parameter syslog_enabled' do
        let(:params) do
          {
            syslog_enabled: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{syslog-enabled yes}
          )
        }
      end

      describe 'with parameter syslog_facility' do
        let(:params) do
          {
            syslog_enabled: true,
            syslog_facility: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{syslog-facility.*_VALUE_}
          )
        }
      end

      describe 'with parameter tcp_backlog' do
        let(:params) do
          {
            tcp_backlog: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^tcp-backlog 42$}
          )
        }
      end

      describe 'with parameter tcp_keepalive' do
        let(:params) do
          {
            tcp_keepalive: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^tcp-keepalive 42$}
          )
        }
      end

      describe 'with parameter timeout' do
        let(:params) do
          {
            timeout: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^timeout 42$}
          )
        }
      end

      describe 'with parameter workdir' do
        let(:params) do
          {
            workdir: '/var/workdir'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^dir /var/workdir$}
          )
        }
      end

      describe 'with parameter zset_max_ziplist_entries' do
        let(:params) do
          {
            zset_max_ziplist_entries: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{zset-max-ziplist-entries 42}
          )
        }
      end

      describe 'with parameter zset_max_ziplist_value' do
        let(:params) do
          {
            zset_max_ziplist_value: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{zset-max-ziplist-value 42}
          )
        }
      end

      describe 'with parameter cluster_enabled-false' do
        let(:params) do
          {
            cluster_enabled: false
          }
        end

        it {
          is_expected.not_to contain_file(config_file_orig).with(
            'content' => %r{^cluster-enabled.*yes}
          )
        }
      end

      describe 'with parameter cluster_enabled-true' do
        let(:params) do
          {
            cluster_enabled: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-enabled.*yes}
          )
        }
      end

      describe 'with parameter cluster_config_file' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_config_file: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{cluster-config-file.*_VALUE_}
          )
        }
      end

      describe 'with parameter cluster_config_file' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_node_timeout: 42
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{cluster-node-timeout 42}
          )
        }
      end

      describe 'with parameter cluster_config_file' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_slave_validity_factor: 1
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{cluster-slave-validity-factor.*1}
          )
        }
      end

      describe 'with parameter cluster_config_file' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_require_full_coverage: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{cluster-require-full-coverage.*yes}
          )
        }
      end

      describe 'with parameter cluster_config_file' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_require_full_coverage: false
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{cluster-require-full-coverage.*no}) }
      end

      describe 'with parameter cluster_config_file' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_migration_barrier: 1
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{cluster-migration-barrier.*1}) }
      end

      describe 'with parameter manage_service_file' do
        let(:params) do
          {
            manage_service_file: true
          }
        end

        it { is_expected.to contain_file(service_file) }

        it do
          content = <<-END.gsub(%r{^\s+\|}, '')
            |[Unit]
            |Description=Redis Advanced key-value store for instance default
            |After=network.target
            |After=network-online.target
            |Wants=network-online.target
            |
            |[Service]
            |RuntimeDirectory=redis
            |RuntimeDirectoryMode=2755
            |Type=#{servicetype}
            |ExecStart=/usr/bin/redis-server #{config_file}#{systemd}
            |ExecStop=/usr/bin/redis-cli -p 6379 shutdown
            |Restart=always
            |User=redis
            |Group=redis
            |LimitNOFILE=65536
            |
            |[Install]
            |WantedBy=multi-user.target
          END

          is_expected.to contain_file(service_file).with_content(content)
        end
      end

      describe 'with parameter manage_service_file' do
        let(:params) do
          {
            manage_service_file: false
          }
        end

        it { is_expected.not_to contain_file(service_file) }
      end

      context 'when $::redis_server_version fact is not present' do
        let(:facts) { super().merge(redis_server_version: nil) }

        context 'when package_ensure is version (3.2.1)' do
          let(:params) { { package_ensure: '3.2.1' } }

          it { is_expected.to contain_file(config_file_orig).with_content(%r{^protected-mode}) }
        end

        context 'when package_ensure is a newer version(4.0-rc3) (older features enabled)' do
          let(:params) { { package_ensure: '4.0-rc3' } }

          it { is_expected.to contain_file(config_file_orig).with_content(%r{^protected-mode}) }
        end
      end

      context 'when $::redis_server_version fact is present but a newer version (older features enabled)' do
        let(:facts) { super().merge(redis_server_version: '3.2.1') }

        it { is_expected.to contain_file(config_file_orig).with_content(%r{^protected-mode}) }
      end

      describe 'test extra_config_file for redis6 config' do
        let(:params) do
          {
            extra_config_file: '/var/redis6/local.conf',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^include /var/redis6/local.conf$}
          )
        }
      end

      describe 'test bind for redis6 config' do
        let(:params) do
          {
            bind: %w[192.168.1.1 172.0.0.1],
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^bind 192.168.1.1 172.0.0.1$}
          )
        }
      end

      describe 'test protected-mode for redis6 config' do
        let(:params) do
          {
            protected_mode: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^protected-mode yes$}
          )
        }
      end

      describe 'test port for redis6 config' do
        let(:params) do
          {
            port: 6378,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^port 6378$}
          )
        }
      end

      describe 'test tcp-backlog for redis6 config' do
        let(:params) do
          {
            tcp_backlog: 1011,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^tcp-backlog 1011$}
          )
        }
      end

      describe 'test unixsocket for redis6 config' do
        let(:params) do
          {
            unixsocket: '/tmp/redis6.sock',
            unixsocketperm: '400',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^unixsocket /tmp/redis6.sock$}
          )
        }
        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^unixsocketperm 400$}
          )
        }
      end

      describe 'test timeout for redis6 config' do
        let(:params) do
          {
            timeout: 17,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^timeout 17$}
          )
        }
      end

      describe 'test tcp-keepalive for redis6 config' do
        let(:params) do
          {
            tcp_keepalive: 1321,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^tcp-keepalive 1321$}
          )
        }
      end

      describe 'test daemonize for redis6 config' do
        let(:params) do
          {
            daemonize: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^daemonize yes$}
          )
        }
      end

      describe 'test pidfile for redis6 config' do
        let(:params) do
          {
            pid_file: '/tmp/redis6.pid',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^pidfile /tmp/redis6.pid$}
          )
        }
      end

      describe 'test loglevel for redis6 config' do
        let(:params) do
          {
            log_level: 'debug',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^loglevel debug$}
          )
        }
      end

      describe 'test logfile for redis6 config' do
        let(:params) do
          {
            log_file: '/tmp/redis6.log',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^logfile /tmp/redis6.log$}
          )
        }
      end

      describe 'test syslog-enabled for redis6 config' do
        let(:params) do
          {
            syslog_enabled: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^syslog-enabled yes$}
          )
        }
      end

      describe 'test syslog-facility for redis6 config' do
        let(:params) do
          {
            syslog_facility: 'local7',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^syslog-facility local7$}
          )
        }
      end

      describe 'test databases for redis6 config' do
        let(:params) do
          {
            databases: 7,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^databases 7$}
          )
        }
      end

      describe 'test save_db_to_disk disabled for redis6 config' do
        let(:params) do
          {
            save_db_to_disk: false,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^save ""$}
          )
        }
      end

      describe 'test save_db_to_disk enabled for redis6 config' do
        let(:params) do
          {
            save_db_to_disk: true,
            save_db_to_disk_interval: { '900' => '1', '300' => '11', '60' => '10011' },
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it { is_expected.to contain_file(config_file_orig).with('content' => %r{save 900 1}) }
        it { is_expected.to contain_file(config_file_orig).with('content' => %r{save 300 11}) }
        it {
          is_expected.to contain_file(config_file_orig).with('content' => %r{save 60 10011})
        }
      end

      describe 'test stop-writes-on-bgsave-error for redis6 config' do
        let(:params) do
          {
            stop_writes_on_bgsave_error: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^stop-writes-on-bgsave-error yes$}
          )
        }
      end

      describe 'test rdbcompression for redis6 config' do
        let(:params) do
          {
            rdbcompression: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^rdbcompression yes$}
          )
        }
      end

      describe 'test dbfilename for redis6 config' do
        let(:params) do
          {
            dbfilename: 'redis6.rdb',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^dbfilename redis6.rdb$}
          )
        }
      end

      describe 'test workdir for redis6 config' do
        let(:params) do
          {
            workdir: '/var/lib/redis6',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^dir /var/lib/redis6$}
          )
        }
      end

      describe 'test slaveof for redis6 config' do
        let(:params) do
          {
            slaveof: 'redis6-master',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^slaveof redis6-master$}
          )
        }
      end

      describe 'test masterauth for redis6 config' do
        let(:params) do
          {
            masterauth: 'secret_password',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^masterauth secret_password$}
          )
        }
      end

      describe 'test replica-serve-stale-data for redis6 config' do
        let(:params) do
          {
            slave_serve_stale_data: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^replica-serve-stale-data yes$}
          )
        }
      end

      describe 'test replica-read-only for redis6 config' do
        let(:params) do
          {
            slave_serve_stale_data: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^replica-read-only yes$}
          )
        }
      end

      describe 'test repl-ping-replica-period for redis6 config' do
        let(:params) do
          {
            repl_ping_slave_period: 1426,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-ping-replica-period 1426$}
          )
        }
      end

      describe 'test repl-timeout for redis6 config' do
        let(:params) do
          {
            repl_timeout: 3,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-timeout 3$}
          )
        }
      end

      describe 'test repl-timeout for redis6 config' do
        let(:params) do
          {
            repl_timeout: 3,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-timeout 3$}
          )
        }
      end

      describe 'test repl-disable-tcp-nodelay for redis6 config' do
        let(:params) do
          {
            repl_disable_tcp_nodelay: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-disable-tcp-nodelay yes$}
          )
        }
      end

      describe 'test repl-backlog-size for redis6 config' do
        let(:params) do
          {
            repl_backlog_size: '5mb',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-backlog-size 5mb$}
          )
        }
      end

      describe 'test repl-backlog-ttl for redis6 config' do
        let(:params) do
          {
            repl_backlog_ttl: 3601,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^repl-backlog-ttl 3601$}
          )
        }
      end

      describe 'test replica-priority for redis6 config' do
        let(:params) do
          {
            slave_priority: 7,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^replica-priority 7$}
          )
        }
      end

      describe 'test replica-priority for redis6 config' do
        let(:params) do
          {
            slave_priority: 47,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^replica-priority 47$}
          )
        }
      end

      describe 'test min-replicas-to-write for redis6 config' do
        let(:params) do
          {
            min_slaves_to_write: 21,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^min-replicas-to-write 21$}
          )
        }
      end

      describe 'test min-replicas-max-lag for redis6 config' do
        let(:params) do
          {
            min_slaves_max_lag: 23,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^min-replicas-max-lag 23$}
          )
        }
      end

      describe 'test requirepass for redis6 config' do
        let(:params) do
          {
            requirepass: 'password_secret',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^requirepass password_secret$}
          )
        }
      end

      describe 'test rename-command for redis6 config' do
        let(:params) do
          {
            rename_commands: { 'CONFIG': 'J29CONFIG' },
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^rename-command CONFIG J29CONFIG$}
          )
        }
      end

      describe 'test maxclients for redis6 config' do
        let(:params) do
          {
            maxclients: 21111,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^maxclients 21111$}
          )
        }
      end

      describe 'test maxmemory for redis6 config' do
        let(:params) do
          {
            maxmemory: '21371mb',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^maxmemory 21371mb$}
          )
        }
      end

      describe 'test maxmemory-policy for redis6 config' do
        let(:params) do
          {
            maxmemory_policy: 'allkeys-lru',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^maxmemory-policy allkeys-lru$}
          )
        }
      end

      describe 'test maxmemory-samples for redis6 config' do
        let(:params) do
          {
            maxmemory_samples: 9,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^maxmemory-samples 9$}
          )
        }
      end

      describe 'test appendonly for redis6 config' do
        let(:params) do
          {
            appendonly: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^appendonly yes$}
          )
        }
      end

      describe 'test appendfilename for redis6 config' do
        let(:params) do
          {
            appendfilename: 'appendonly6378.aof',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^appendfilename appendonly6378.aof$}
          )
        }
      end

      describe 'test appendfsync for redis6 config' do
        let(:params) do
          {
            appendfsync: 'no',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^appendfsync no$}
          )
        }
      end

      describe 'test no-appendfsync-on-rewrite for redis6 config' do
        let(:params) do
          {
            no_appendfsync_on_rewrite: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^no-appendfsync-on-rewrite yes$}
          )
        }
      end

      describe 'test auto-aof-rewrite-percentage for redis6 config' do
        let(:params) do
          {
            auto_aof_rewrite_percentage: 71,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^auto-aof-rewrite-percentage 71$}
          )
        }
      end

      describe 'test auto-aof-rewrite-min-size for redis6 config' do
        let(:params) do
          {
            auto_aof_rewrite_min_size: '32mb',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^auto-aof-rewrite-min-size 32mb$}
          )
        }
      end

      describe 'test aof-load-truncated for redis6 config' do
        let(:params) do
          {
            aof_load_truncated: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^aof-load-truncated yes$}
          )
        }
      end

      describe 'test cluster mode for redis6 config' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_config_file: 'nodes6.conf',
            cluster_node_timeout: 10001,
            cluster_slave_validity_factor: 1,
            cluster_require_full_coverage: false,
            cluster_migration_barrier: 2,
            cluster_allow_reads_when_down: true,
            cluster_replica_no_failover: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-enabled yes$}
          )
        }
        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-config-file nodes6.conf$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-node-timeout 10001$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-replica-validity-factor 1$}
          )
        }
        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-require-full-coverage no$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-migration-barrier 2$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-allow-reads-when-down yes$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^cluster-replica-no-failover yes$}
          )
        }
      end

      describe 'test slowlog-log-slower-than for redis6 config' do
        let(:params) do
          {
            slowlog_log_slower_than: 1000,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^slowlog-log-slower-than 1000$}
          )
        }
      end

      describe 'test slowlog-max-len for redis6 config' do
        let(:params) do
          {
            slowlog_max_len: 112,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^slowlog-max-len 112$}
          )
        }
      end

      describe 'test latency-monitor-threshold for redis6 config' do
        let(:params) do
          {
            latency_monitor_threshold: 509,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^latency-monitor-threshold 509$}
          )
        }
      end

      describe 'test notify-keyspace-events for redis6 config' do
        let(:params) do
          {
            notify_keyspace_events: 'Ex',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^notify-keyspace-events Ex$}
          )
        }
      end

      describe 'test hash-max-ziplist-entries for redis6 config' do
        let(:params) do
          {
            hash_max_ziplist_entries: 342,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^hash-max-ziplist-entries 342$}
          )
        }
      end

      describe 'test hash-max-ziplist-value for redis6 config' do
        let(:params) do
          {
            hash_max_ziplist_value: 2557,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^hash-max-ziplist-value 2557$}
          )
        }
      end

      describe 'test list-max-ziplist-entries for redis6 config' do
        let(:params) do
          {
            list_max_ziplist_entries: 16556,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^list-max-ziplist-entries 16556$}
          )
        }
      end

      describe 'test list-max-ziplist-value for redis6 config' do
        let(:params) do
          {
            list_max_ziplist_value: 15681,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^list-max-ziplist-value 15681$}
          )
        }
      end

      describe 'test set-max-intset-entries for redis6 config' do
        let(:params) do
          {
            set_max_intset_entries: 14597,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^set-max-intset-entries 14597$}
          )
        }
      end

      describe 'test zset-max-ziplist-entries for redis6 config' do
        let(:params) do
          {
            zset_max_ziplist_entries: 4487,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^zset-max-ziplist-entries 4487$}
          )
        }
      end

      describe 'test zset-max-ziplist-value for redis6 config' do
        let(:params) do
          {
            zset_max_ziplist_value: 2603,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^zset-max-ziplist-value 2603$}
          )
        }
      end

      describe 'test hll-sparse-max-bytes for redis6 config' do
        let(:params) do
          {
            hll_sparse_max_bytes: 985,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^hll-sparse-max-bytes 985$}
          )
        }
      end

      describe 'test activerehashing for redis6 config' do
        let(:params) do
          {
            activerehashing: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^activerehashing yes$}
          )
        }
      end

      describe 'test client-output-buffer-limit replica for redis6 config' do
        let(:params) do
          {
            output_buffer_limit_slave: '251mb 63mb 59',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^client-output-buffer-limit replica 251mb 63mb 59$}
          )
        }
      end

      describe 'test client-output-buffer-limit pubsub for redis6 config' do
        let(:params) do
          {
            output_buffer_limit_pubsub: '253mb 61mb 57',
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^client-output-buffer-limit pubsub 253mb 61mb 57$}
          )
        }
      end

      describe 'test hz for redis6 config' do
        let(:params) do
          {
            hz: 314,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^hz 314$}
          )
        }
      end

      describe 'test aof-rewrite-incremental-fsync for redis6 config' do
        let(:params) do
          {
            aof_rewrite_incremental_fsync: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^aof-rewrite-incremental-fsync yes$}
          )
        }
      end

      describe 'test io-threads for redis6 config' do
        let(:params) do
          {
            conf_template: "redis/redis6.conf.epp",
            io_threads: 4
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^io-threads 4$}
          )
        }
      end

      describe 'test io-threads-do-reads for redis6 config' do
        let(:params) do
          {
            io_threads_do_reads: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^io-threads-do-reads yes$}
          )
        }
      end

      describe 'test dynamic-hz for redis6 config' do
        let(:params) do
          {
            dynamic_hz: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^dynamic-hz yes$}
          )
        }
      end

      describe 'test activedefrag for redis6 config' do
        let(:params) do
          {
            activedefrag: false,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^activedefrag no$}
          )
        }
      end

      describe 'test jemalloc-bg-thread for redis6 config' do
        let(:params) do
          {
            jemalloc_bg_thread: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^jemalloc-bg-thread yes$}
          )
        }
      end

      describe 'test activedefrag configuration for redis6 config' do
        let(:params) do
          {
            activedefrag: true,
            active_defrag_ignore_bytes: '200mb',
            active_defrag_threshold_lower: 11,
            active_defrag_threshold_upper: 99,
            active_defrag_cycle_min: 7,
            active_defrag_cycle_max: 23,
            active_defrag_max_scan_fields: 1341,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^activedefrag yes$}
          )
        }
        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^active-defrag-ignore-bytes 200mb$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^active-defrag-threshold-lower 11$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^active-defrag-threshold-upper 99$}
          )
        }
        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^active-defrag-cycle-min 7$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^active-defrag-cycle-max 23$}
          )
        }

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^active-defrag-max-scan-fields 1341$}
          )
        }
      end

      describe 'test rdb-save-incremental-fsync for redis6 config' do
        let(:params) do
          {
            rdb_save_incremental_fsync: true,
            conf_template: "redis/redis6.conf.epp"
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^rdb-save-incremental-fsync yes$}
          )
        }
      end

    end
  end
end
