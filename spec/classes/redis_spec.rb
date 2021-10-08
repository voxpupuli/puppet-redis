require 'spec_helper'

describe 'redis' do
  let(:package_name) { facts[:osfamily] == 'Debian' ? 'redis-server' : 'redis' }
  let(:service_name) { package_name }
  let(:config_file) do
    case facts[:osfamily]
    when 'Archlinux', 'Debian'
      '/etc/redis/redis.conf'
    when 'FreeBSD'
      '/usr/local/etc/redis.conf'
    when 'RedHat'
      '/etc/redis.conf'
    end
  end
  let(:config_file_orig) { "#{config_file}.puppet" }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'without parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('redis') }
        it { is_expected.to contain_class('redis::preinstall') }
        it { is_expected.to contain_class('redis::install') }
        it { is_expected.to contain_class('redis::config') }
        it { is_expected.to contain_class('redis::service') }

        it { is_expected.to contain_package(package_name).with_ensure('installed') }

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

        it { is_expected.to contain_service(service_name).with_ensure('running').with_enable('true') }

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
              'ensure'  => 'file',
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0644',
              'content' => "redis soft nofile 65536\nredis hard nofile 65536\n"
            )
          end
        end
      end

      describe 'with parameter ulimit_managed' do
        context 'true' do
          let(:params) { { ulimit: 7777, ulimit_managed: true } }

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.to contain_file("/etc/systemd/system/#{service_name}.service.d/limit.conf").
              with_ensure('absent')

            is_expected.to contain_systemd__service_limits("#{service_name}.service").
              with_limits({ 'LimitNOFILE' => 7777 }).
              with_restart_service(false).
              with_ensure('present')
          end
        end

        context 'false' do
          let(:params) { { ulimit_managed: false } }

          it { is_expected.to compile.with_all_deps }
          it do
            is_expected.not_to contain_systemd__service_limits("#{service_name}.service")
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

        describe 'empty string' do
          let(:params) { { unixsocket: '' } }

          it { is_expected.to contain_file(config_file_orig).without_content(%r{^unixsocket }) }
        end
      end

      describe 'with parameter unixsocketperm' do
        describe '777' do
          let(:params) { { unixsocketperm: '777' } }

          it { is_expected.to contain_file(config_file_orig).with_content(%r{^unixsocketperm 777$}) }
        end

        describe 'empty string' do
          let(:params) { { unixsocketperm: '' } }

          it { is_expected.to contain_file(config_file_orig).without_content(%r{^unixsocketperm }) }
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
            maxmemory_policy: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{maxmemory-policy.*_VALUE_}
          )
        }
      end

      describe 'with parameter maxmemory_samples' do
        let(:params) do
          {
            maxmemory_samples: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{maxmemory-samples.*_VALUE_}
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

        it { is_expected.to contain_file(config_file_orig).with_content(%r{^protected-mode no$}) }
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
              rename_commands: { CONFIG: '""' }
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
              rename_commands: { CONFIG: '""', RENAME: '""' }
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
              'rename_commands' => {}
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
        context 'set to a value great or equal to zero' do
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

        context 'set to -1 (disabled)' do
          let(:params) do
            { slowlog_log_slower_than: -1 }
          end

          it {
            is_expected.to contain_file(config_file_orig).with(
              'content' => %r{^slowlog-log-slower-than -1$}
            )
          }
        end
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
            'content' => %r{cluster-enabled}
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
            'content' => %r{cluster-enabled.*yes}
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

        it { is_expected.to contain_systemd__unit_file("#{service_name}.service") }

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
            |Type=notify
            |ExecStart=/usr/bin/redis-server #{config_file} --supervised systemd
            |ExecStop=/usr/bin/redis-cli -p 6379 shutdown
            |Restart=always
            |User=redis
            |Group=redis
            |LimitNOFILE=65536
            |
            |[Install]
            |WantedBy=multi-user.target
          END

          is_expected.to contain_systemd__unit_file("#{service_name}.service").with_content(content)
        end
      end

      describe 'with parameter manage_service_file set to false' do
        let(:params) do
          {
            manage_service_file: false
          }
        end

        it { is_expected.not_to contain_systemd__unit_file("#{service_name}.service") }
      end

      describe 'with parameter tls_port' do
        let(:params) do
          {
            tls_port: 7777
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^tls_port 7777$}
          )
        }
      end

      describe 'with parameter tls_cert_file' do
        let(:params) do
          {
            tls_cert_file: '/etc/pki/some/path/localhost.crt'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_cert_file.*\/etc\/pki\/some\/path\/localhost\.crt}
          )
        }
      end

      describe 'with parameter tls_key_file' do
        let(:params) do
          {
            tls_key_file: '/etc/pki/some/path/localhost.key'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_key_file.*\/etc\/pki\/some\/path\/localhost\.key}
          )
        }
      end

      describe 'with parameter tls_ca_cert_file' do
        let(:params) do
          {
            tls_ca_cert_file: '/etc/pki/some/path/ca.crt'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_ca_cert_file.*\/etc\/pki/some\/path\/ca\.crt}
          )
        }
      end

      describe 'with parameter tls_ca_cert_dir' do
        let(:params) do
          {
            tls_cert_dir: '/etc/pki/some/path'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_cert_dir.*\/etc\/pki\/some\/path}
          )
        }
      end

      describe 'with parameter tls_auth_clients' do
        let(:params) do
          {
            tls_auth_clients: 'no' 
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_auth_clients.*no}
          )
        }
      end

      describe 'with parameter tls_replication' do
        let(:params) do
          {
            tls_replication: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_replication.*yes}
          )
        }
      end

      describe 'with parameter tls_cluster' do
        let(:params) do
          {
            tls_cluster: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_cluster.*yes}
          )
        }
      end

      describe 'with parameter tls_ciphers' do
        let(:params) do
          {
            tls_ciphers: 'DEFAULT:!MEDIUM'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_ciphers.*DEFAULT:!MEDIUM}
          )
        }
      end

      describe 'with parameter tls_ciphersuites' do
        let(:params) do
          {
            tls_ciphersuites: 'TLS_CHACHA20_POLY1305_SHA256'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_ciphersuites.*TLS_CHACHA20_POLY1305_SHA256}
          )
        }
      end

      describe 'with parameter tls_protocols' do
        let(:params) do
          {
            tls_protocols: 'TLSv1.2 TLSv1.3'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_protocols.*TLSv1\.2 TLSv1\.3}
          )
        }
      end

      describe 'with parameter tls_tls_prefer_server_ciphers' do
        let(:params) do
          {
            tls_prefer_server_ciphers: true
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tls_prefer_server_ciphers.*yes}
          )
        }
      end
    end
  end
end
