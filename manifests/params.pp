# @summary This class provides a number of parameters.
# @api private
class redis::params {
  # Generic
  $manage_repo                = false
  $manage_package             = true
  $managed_by_cluster_manager = false

  # redis.conf.erb
  $activerehashing                 = true
  $aof_load_truncated              = true
  $aof_rewrite_incremental_fsync   = true
  $appendfilename                  = 'appendonly.aof'
  $appendfsync                     = 'everysec'
  $appendonly                      = false
  $auto_aof_rewrite_min_size       = '64mb'
  $auto_aof_rewrite_percentage     = 100
  $bind                            = ['127.0.0.1']
  $output_buffer_limit_slave       = '256mb 64mb 60'
  $output_buffer_limit_pubsub      = '32mb 8mb 60'
  $conf_template                   = 'redis/redis.conf.erb'
  $default_install                 = true
  $databases                       = 16
  $dbfilename                      = 'dump.rdb'
  $extra_config_file               = undef
  $hash_max_ziplist_entries        = 512
  $hash_max_ziplist_value          = 64
  $hll_sparse_max_bytes            = 3000
  $hz                              = 10
  $latency_monitor_threshold       = 0
  $list_max_ziplist_entries        = 512
  $list_max_ziplist_value          = 64
  $log_dir                         = '/var/log/redis'
  $log_file                        = '/var/log/redis/redis.log'
  $log_level                       = 'notice'
  $manage_service_file             = false
  $maxclients                      = 10000
  $maxmemory                       = undef
  $maxmemory_policy                = undef
  $maxmemory_samples               = undef
  $no_appendfsync_on_rewrite       = false
  $notify_keyspace_events          = undef
  $notify_service                  = true
  $port                            = 6379
  $protected_mode                  = 'yes'
  $rdbcompression                  = true
  $requirepass                     = undef
  $save_db_to_disk                 = true
  $save_db_to_disk_interval        = {'900' =>'1', '300' => '10', '60' => '10000'}
  $service_provider                = undef
  $set_max_intset_entries          = 512
  $slave_priority                  = 100
  $slowlog_log_slower_than         = 10000
  $slowlog_max_len                 = 1024
  $stop_writes_on_bgsave_error     = true
  $syslog_enabled                  = undef
  $syslog_facility                 = undef
  $tcp_backlog                     = 511
  $tcp_keepalive                   = 0
  $timeout                         = 0
  $ulimit                          = 65536
  $unixsocket                      = '/var/run/redis/redis.sock'
  $unixsocketperm                  = 755
  $zset_max_ziplist_entries        = 128
  $zset_max_ziplist_value          = 64

  # redis.conf.erb - replication
  $masterauth               = undef
  $min_slaves_to_write      = 0
  $min_slaves_max_lag       = 10
  $repl_backlog_size        = '1mb'
  $repl_backlog_ttl         = 3600
  $repl_disable_tcp_nodelay = false
  $repl_ping_slave_period   = 10
  $repl_timeout             = 60
  $slave_read_only          = true
  $slave_serve_stale_data   = true
  $slaveof                  = undef

  # redis.conf.erb - redis 3.0 clustering
  $cluster_enabled        = false
  $cluster_config_file    = 'nodes.conf'
  $cluster_node_timeout   = 5000
  $cluster_slave_validity_factor = 0
  $cluster_require_full_coverage = true
  $cluster_migration_barrier = 1

  case $::osfamily {
    'Debian': {
      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis/redis.conf'
      $config_file_mode          = '0644'
      $config_file_orig          = '/etc/redis/redis.conf.puppet'

      $config_owner              = 'redis'
      $daemonize                 = true
      $log_dir_mode              = '0755'
      $package_ensure            = 'present'
      $package_name              = 'redis-server'
      $pid_file                  = '/var/run/redis/redis-server.pid'
      $sentinel_config_file      = '/etc/redis/sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = '/etc/init.d/redis-sentinel'
      $sentinel_package_name     = 'redis-sentinel'
      $service_manage            = true
      $service_enable            = true
      $service_ensure            = 'running'
      $service_group             = 'redis'
      $service_hasrestart        = true
      $service_hasstatus         = true
      $service_name              = 'redis-server'
      $service_user              = 'redis'
      $ppa_repo                  = 'ppa:chris-lea/redis-server'
      $workdir                   = '/var/lib/redis'
      $workdir_mode              = '0750'

      case $facts['os']['name'] {
        'Ubuntu': {
          $config_group = 'redis'
          $minimum_version = $facts['os']['release']['major'] ? {
            '16.04' => '3.0.5',
            default => '4.0.9',
          }
        }
        default: {
          $config_group              = 'root'
          $minimum_version           = '3.2.5'
        }
      }

    }

    'RedHat': {
      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis.conf'
      $config_file_mode          = '0644'
      $config_file_orig          = '/etc/redis.conf.puppet'
      $config_group              = 'root'
      $config_owner              = 'redis'
      $daemonize                 = true
      $log_dir_mode              = '0755'
      $package_ensure            = 'present'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis.pid'
      $sentinel_config_file      = '/etc/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = false
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'
      $service_manage            = true
      $service_enable            = true
      $service_ensure            = 'running'
      $service_hasrestart        = true
      $service_hasstatus         = true
      $service_name              = 'redis'
      $service_user              = 'redis'
      $ppa_repo                  = undef
      $workdir                   = '/var/lib/redis'
      $workdir_mode              = '0755'

      # EPEL 6 and newer have 3.2 so we can assume all EL is 3.2+
      $minimum_version           = '3.2.10'

      $service_group = $facts['os']['release']['major'] ? {
        '6'     => 'root',
        default => 'redis',
      }
    }

    'FreeBSD': {
      $config_dir                = '/usr/local/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/usr/local/etc/redis.conf'
      $config_file_mode          = '0644'
      $config_file_orig          = '/usr/local/etc/redis.conf.puppet'
      $config_group              = 'wheel'
      $config_owner              = 'redis'
      $daemonize                 = true
      $log_dir_mode              = '0755'
      $package_ensure            = 'present'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis.pid'
      $sentinel_config_file      = '/usr/local/etc/redis-sentinel.conf'
      $sentinel_config_file_orig = '/usr/local/etc/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'
      $service_manage            = true
      $service_enable            = true
      $service_ensure            = 'running'
      $service_group             = 'redis'
      $service_hasrestart        = true
      $service_hasstatus         = true
      $service_name              = 'redis'
      $service_user              = 'redis'
      $ppa_repo                  = undef
      $workdir                   = '/var/db/redis'
      $workdir_mode              = '0750'

      # pkg version
      $minimum_version           = '3.2.4'
    }

    'Suse': {
      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0750'
      $config_file               = '/etc/redis/redis-server.conf'
      $config_file_mode          = '0644'
      $config_group              = 'redis'
      $config_owner              = 'redis'
      $daemonize                 = true
      $log_dir_mode              = '0750'
      $package_ensure            = 'present'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis-server.pid'
      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'
      $service_manage            = true
      $service_enable            = true
      $service_ensure            = 'running'
      $service_group             = 'redis'
      $service_hasrestart        = true
      $service_hasstatus         = true
      $service_name              = 'redis'
      $service_user              = 'redis'
      $ppa_repo                  = undef
      $workdir                   = '/var/lib/redis'
      $workdir_mode              = '0750'

      # suse package version
      $minimum_version           = '3.0.5'
    }

    'Archlinux': {
      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis/redis.conf'
      $config_file_mode          = '0644'
      $config_file_orig          = '/etc/redis/redis.conf.puppet'
      $config_group              = 'root'
      $config_owner              = 'root'
      $daemonize                 = true
      $log_dir_mode              = '0755'
      $package_ensure            = 'present'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis.pid'
      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'
      $service_manage            = true
      $service_enable            = true
      $service_ensure            = 'running'
      $service_group             = 'redis'
      $service_hasrestart        = true
      $service_hasstatus         = true
      $service_name              = 'redis'
      $service_user              = 'redis'
      $ppa_repo                  = undef
      $workdir                   = '/var/lib/redis'
      $workdir_mode              = '0750'

      # pkg version
      $minimum_version           = '3.2.4'
    }
    default: {
      fail "Operating system ${::operatingsystem} is not supported yet."
    }
  }
}
