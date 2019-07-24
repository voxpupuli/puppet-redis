require 'spec_helper'

describe 'redis', type: :class do
  let(:service_file) { redis_service_file(service_provider: facts[:service_provider]) }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        merged_facts = facts.merge(redis_server_version: '3.2.3')

        if facts[:operatingsystem].casecmp('archlinux') == 0
          merged_facts = merged_facts.merge(service_provider: 'systemd')
        end

        merged_facts
      end

      let(:package_name) { manifest_vars[:package_name] }
      let(:service_name) { manifest_vars[:service_name] }
      let(:config_file_orig) { manifest_vars[:config_file_orig] }

      describe 'without parameters' do
        it { is_expected.to create_class('redis') }
        it { is_expected.to contain_class('redis::preinstall') }
        it { is_expected.to contain_class('redis::install') }
        it { is_expected.to contain_class('redis::config') }
        it { is_expected.to contain_class('redis::service') }

        it { is_expected.to contain_package(package_name).with_ensure('present') }

        it { is_expected.to contain_file(config_file_orig).with_ensure('file') }

        it { is_expected.to contain_file(config_file_orig).without_content(%r{undef}) }

        it do
          is_expected.to contain_service(service_name).with(
            'ensure'     => 'running',
            'enable'     => 'true',
            'hasrestart' => 'true',
            'hasstatus'  => 'true'
          )
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
            auto_aof_rewrite_percentage: '_VALUE_'
          }
        end

        it { is_expected.to contain_file(config_file_orig).with_content(%r{auto-aof-rewrite-percentage.*_VALUE_}) }
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
        context 'with multiple IP addresses on redis 2.4' do
          let(:params) do
            {
              package_ensure: '2.4.10',
              bind: ['127.0.0.1', '::1']
            }
          end

          it { is_expected.to compile.and_raise_error(%r{Redis 2\.4 doesn't support binding to multiple IPs}) }
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
        let(:params) { { config_file_orig: '_VALUE_' } }

        it { is_expected.to contain_file('_VALUE_') }
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
            databases: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{databases.*_VALUE_}
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
            hash_max_ziplist_entries: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{hash-max-ziplist-entries.*_VALUE_}
          )
        }
      end

      describe 'with parameter hash_max_ziplist_value' do
        let(:params) do
          {
            hash_max_ziplist_value: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{hash-max-ziplist-value.*_VALUE_}
          )
        }
      end

      describe 'with parameter list_max_ziplist_entries' do
        let(:params) do
          {
            list_max_ziplist_entries: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{list-max-ziplist-entries.*_VALUE_}
          )
        }
      end

      describe 'with parameter list_max_ziplist_value' do
        let(:params) do
          {
            list_max_ziplist_value: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{list-max-ziplist-value.*_VALUE_}
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
        let(:params) do
          {
            log_file: '/var/log/redis/redis.log'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{^logfile /var/log/redis/redis\.log$}
          )
        }
      end

      describe 'with parameter log_level' do
        let(:params) do
          {
            log_level: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{loglevel.*_VALUE_}
          )
        }
      end

      describe 'with parameter: manage_repo' do
        let(:params) { { manage_repo: true } }

        case facts[:operatingsystem]

        when 'Debian'

          context 'on Debian' do
            it do
              is_expected.to create_apt__source('dotdeb').with(location: 'http://packages.dotdeb.org/',
                                                               release: facts[:lsbdistcodename],
                                                               repos: 'all',
                                                               key: {
                                                                 'id' => '6572BBEF1B5FF28B28B706837E3F070089DF5277',
                                                                 'source' => 'http://www.dotdeb.org/dotdeb.gpg'
                                                               },
                                                               include: { 'src' => true })
            end
          end

        when 'Ubuntu'

          let(:ppa_repo) { manifest_vars[:ppa_repo] }

          it { is_expected.to contain_apt__ppa(ppa_repo) }

        when 'RedHat', 'CentOS', 'Scientific', 'OEL', 'Amazon'

          it { is_expected.to contain_class('epel') }

        end
      end

      describe 'with parameter unixsocket' do
        let(:params) do
          {
            unixsocket: '/tmp/redis.sock'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{unixsocket.*/tmp/redis\.sock}
          )
        }
      end

      describe 'with parameter unixsocketperm' do
        let(:params) do
          {
            unixsocketperm: '777'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{unixsocketperm.*777}
          )
        }
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
            maxclients: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{maxclients.*_VALUE_}
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
            min_slaves_max_lag: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{min-slaves-max-lag.*_VALUE_}
          )
        }
      end

      describe 'with parameter min_slaves_to_write' do
        let(:params) do
          {
            min_slaves_to_write: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{min-slaves-to-write.*_VALUE_}
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

        let(:service_name) { manifest_vars[:service_name] }

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
        let(:package_name) { manifest_vars[:package_name] }

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
            pid_file: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{pidfile.*_VALUE_}
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
            protected_mode: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{protected-mode.*_VALUE_}
          )
        }
      end

      describe 'with parameter hll_sparse_max_bytes' do
        let(:params) do
          {
            hll_sparse_max_bytes: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{hll-sparse-max-bytes.*_VALUE_}
          )
        }
      end

      describe 'with parameter hz' do
        let(:params) do
          {
            hz: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{hz.*_VALUE_}
          )
        }
      end

      describe 'with parameter latency_monitor_threshold' do
        let(:params) do
          {
            latency_monitor_threshold: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{latency-monitor-threshold.*_VALUE_}
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
            repl_backlog_ttl: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{repl-backlog-ttl.*_VALUE_}
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
        let(:package_name) { manifest_vars[:package_name] }

        it { is_expected.not_to contain_service(package_name) }
      end

      describe 'with parameter: service_enable' do
        let(:params) { { service_enable: true } }
        let(:package_name) { manifest_vars[:package_name] }

        it { is_expected.to contain_service(package_name).with_enable(true) }
      end

      describe 'with parameter: service_ensure' do
        let(:params) { { service_ensure: '_VALUE_' } }
        let(:package_name) { manifest_vars[:package_name] }

        it { is_expected.to contain_service(package_name).with_ensure('_VALUE_') }
      end

      describe 'with parameter: service_group' do
        let(:params) { { service_group: '_VALUE_' } }

        it { is_expected.to contain_file('/var/log/redis').with_group('_VALUE_') }
      end

      describe 'with parameter: service_hasrestart' do
        let(:params) { { service_hasrestart: true } }
        let(:package_name) { manifest_vars[:package_name] }

        it { is_expected.to contain_service(package_name).with_hasrestart(true) }
      end

      describe 'with parameter: service_hasstatus' do
        let(:params) { { service_hasstatus: true } }
        let(:package_name) { manifest_vars[:package_name] }

        it { is_expected.to contain_service(package_name).with_hasstatus(true) }
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
            set_max_intset_entries: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{set-max-intset-entries.*_VALUE_}
          )
        }
      end

      describe 'with parameter slave_priority' do
        let(:params) do
          {
            slave_priority: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{slave-priority.*_VALUE_}
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
            slowlog_log_slower_than: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{slowlog-log-slower-than.*_VALUE_}
          )
        }
      end

      describe 'with parameter slowlog_max_len' do
        let(:params) do
          {
            slowlog_max_len: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{slowlog-max-len.*_VALUE_}
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
            tcp_backlog: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tcp-backlog.*_VALUE_}
          )
        }
      end

      describe 'with parameter tcp_keepalive' do
        let(:params) do
          {
            tcp_keepalive: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{tcp-keepalive.*_VALUE_}
          )
        }
      end

      describe 'with parameter timeout' do
        let(:params) do
          {
            timeout: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{timeout.*_VALUE_}
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
            zset_max_ziplist_entries: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{zset-max-ziplist-entries.*_VALUE_}
          )
        }
      end

      describe 'with parameter zset_max_ziplist_value' do
        let(:params) do
          {
            zset_max_ziplist_value: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{zset-max-ziplist-value.*_VALUE_}
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
            cluster_node_timeout: '_VALUE_'
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{cluster-node-timeout.*_VALUE_}
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

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{cluster-require-full-coverage.*no}
          )
        }
      end

      describe 'with parameter cluster_config_file' do
        let(:params) do
          {
            cluster_enabled: true,
            cluster_migration_barrier: 1
          }
        end

        it {
          is_expected.to contain_file(config_file_orig).with(
            'content' => %r{cluster-migration-barrier.*1}
          )
        }
      end

      describe 'with parameter manage_service_file' do
        let(:params) do
          {
            manage_service_file: true
          }
        end

        it {
          is_expected.to contain_file(service_file)
        }
      end

      describe 'with parameter manage_service_file' do
        let(:params) do
          {
            manage_service_file: false
          }
        end

        it {
          is_expected.not_to contain_file(service_file)
        }
      end
    end
  end
end
