# == Class: redis::params
#
# This class provides a number of parameters.
#
class redis::params {
  # Generic
  $manage_repo = false

  # redis.conf.erb
  $activerehashing             = 'yes'
  $appendfsync                 = 'everysec'
  $appendonly                  = 'no'
  $auto_aof_rewrite_min_size   = '64min'
  $auto_aof_rewrite_percentage = '100'
  $bind                        = '127.0.0.1'
  $daemonize                   = 'yes'
  $databases                   = '16'
  $dbfilename                  = 'dump.rdb'
  $hash_max_zipmap_entries     = '512'
  $hash_max_zipmap_value       = '64'
  $list_max_ziplist_entries    = '512'
  $list_max_ziplist_value      = '64'
  $log_dir                     = '/var/log/redis'
  $log_file                    = '/var/log/redis/redis.log'
  $log_level                   = 'notice'
  $maxclients                  = '0'
  $maxmemory                   = undef
  $maxmemory_policy            = undef
  $maxmemory_samples           = undef
  $no_appendfsync_on_rewrite   = 'no'
  $pid_file                    = '/var/run/redis/redis.pid'
  $port                        = '6379'
  $rdbcompression              = 'yes'
  $requirepass                 = undef
  $set_max_intset_entries      = '512'
  $slowlog_log_slower_than     = '10000'
  $slowlog_max_len             = '1024'
  $timeout                     = '0'
  $vm_max_memory               = '0'
  $vm_max_threads              = '4'
  $vm_page_size                = '32'
  $vm_pages                    = '134217728'
  $vm_swap_file                = '/tmp/redis.swap'
  $workdir                     = '/var/lib/redis/'
  $zset_max_ziplist_entries    = '128'
  $zset_max_ziplist_value      = '64'

  # redis.conf.erb - replication
  $masterauth             = undef
  $repl_ping_slave_period = '10'
  $repl_timeout           = '60'
  $slave_serve_stale_data = 'yes'
  $slaveof                = undef

  case $::osfamily {
    'Debian': {
      $config_dir        = '/etc/redis'
      $config_dir_mode   = '0755'
      $config_file       = '/etc/redis.conf'
      $config_file_mode  = '0644'
      $config_group      = 'root'
      $config_user       = 'root'
      $package_deps      = ''
      $package_ensure    = 'present'
      $package_name      = 'redis-server'
      $service_enable     = true
      $service_ensure     = 'running'
      $service_group      = 'redis'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_name       = 'redis'
      $service_user       = 'redis'
    }

    'RedHat': {
      $config_dir        = '/etc/redis'
      $config_dir_mode   = '0755'
      $config_file       = '/etc/redis.conf'
      $config_file_mode  = '0644'
      $config_group      = 'root'
      $config_user       = 'root'
      $package_deps      = ''
      $package_ensure    = 'present'
      $package_name      = 'redis'
      $service_enable     = true
      $service_ensure     = 'running'
      $service_group      = 'redis'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_name       = 'redis'
      $service_user       = 'redis'
    }

    default: {
      fail "Operating system ${::operatingsystem} is not supported yet."
    }
  }
}

