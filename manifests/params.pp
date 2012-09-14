# = Class: redis::params
#
# This class provides a number of parameters.
#
class redis::params {
  # Generic
  $config_dir        = '/etc/redis'
  $config_file       = '/etc/redis.conf'
  $config_group      = 'root'
  $config_user       = 'root'
  $daemon_enable     = true
  $daemon_ensure     = 'running'
  $daemon_group      = 'redis'
  $daemon_hasstatus  = true
  $daemon_user       = 'redis'
  $manage_repo       = false
  $package_ensure    = 'present'

  # redis.conf.erb
  $activerehashing              = 'yes'
  $appendfsync                  = 'everysec'
  $appendonly                   = 'no'
  $auto_aof_rewrite_min_size    = '64min'
  $auto_aof_rewrite_percentage  = '100'
  $bind                         = '127.0.0.1'
  $daemonize                    = 'yes'
  $databases                    = '16'
  $dbfilename                   = 'dump.rdb'
  $hash_max_zipmap_entries      = '512'
  $hash_max_zipmap_value        = '64'
  $list_max_ziplist_entries     = '512'
  $list_max_ziplist_value       = '64'
  $log_dir                      = '/var/log/redis'
  $log_file                     = '/var/log/redis/redis.log'
  $log_level                    = 'notice'
  $maxclients                   = '0'
  $maxmemory                    = undef
  $maxmemory_policy             = undef
  $maxmemory_samples            = undef
  $no_appendfsync_on_rewrite    = 'no'
  $pid_file                     = '/var/run/redis/redis.pid'
  $port                         = '6379'
  $rdbcompression               = 'yes'
  $requirepass                  = undef
  $set_max_intset_entries       = '512'
  $slowlog_log_slower_than      = '10000'
  $slowlog_max_len              = '1024'
  $timeout                      = '0'
  $vm_max_memory                = '0'
  $vm_max_threads               = '4'
  $vm_page_size                 = '32'
  $vm_pages                     = '134217728'
  $vm_swap_file                 = '/tmp/redis.swap'
  $workdir                      = '/var/lib/redis/'
  $zset_max_ziplist_entries     = '128'
  $zset_max_ziplist_value       = '64'

  # redis.conf.erb - replication
  $masterauth             = undef
  $repl_ping_slave_period = '10'
  $repl_timeout           = '60'
  $slave_serve_stale_data = 'yes'
  $slaveof                = undef

  case $::operatingsystem {
    'debian', 'ubuntu': {
      $daemon_name  = 'redis'
      $package_deps = ''
      $package_name = 'redis-server'
    }

    'RedHat', 'CentOS', 'Scientific', 'OEL', 'Amazon': {
      $daemon_name  = 'redis'
      $package_deps = ''
      $package_name = 'redis'
    }

    default: {
      fail "Operating system ${::operatingsystem} is not supported yet."
    }
  }
}

