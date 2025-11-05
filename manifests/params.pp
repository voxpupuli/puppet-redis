# @summary This class provides a number of parameters.
# @api private
class redis::params {
  case $facts['os']['family'] {
    'Debian': {
      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis/redis.conf'
      $config_file_orig          = '/etc/redis/redis.conf.puppet'
      $config_owner              = 'redis'
      $log_dir                   = '/var/log/redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis-server'
      $pid_file                  = '/var/run/redis/redis-server.pid'
      $workdir                   = '/var/lib/redis'
      $bin_path                  = '/usr/bin'
      $daemonize                 = true
      $service_name              = 'redis-server'
      $ulimit                    = undef
      $package_ensure            = 'present'
      $appendonly                = 'no'
      $save_db_to_disk           = false

      $sentinel_config_file      = '/etc/redis/sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_package_name     = 'redis-sentinel'
      $sentinel_log_file         = '/var/log/redis/redis-sentinel.log'
      $sentinel_working_dir      = '/var/lib/redis'

      case $facts['os']['name'] {
        'Ubuntu': {
          $config_group = 'redis'
          $sentinel_pid_file =  '/var/run/sentinel/redis-sentinel.pid'
        }
        default: {
          $config_group              = 'root'
          $sentinel_pid_file         = '/run/sentinel/redis-sentinel.pid'
        }
      }
    }

    'RedHat': {
      $daemonize            = false
      $config_owner         = 'redis'
      $config_group         = 'root'
      $config_dir_mode      = '0755'
      $log_dir_mode         = '0750'
      $ulimit                = undef
      $package_ensure        = 'present'
      $appendonly            = 'no'
      $save_db_to_disk       = false

      $sentinel_daemonize   = false
      $sentinel_working_dir = '/tmp'

      $config_dir                  = '/etc/redis'
      if (versioncmp($facts['os']['release']['major'], '9') >= 0) {
        $config_file               = '/etc/redis/redis.conf'
        $config_file_orig          = '/etc/redis/redis.conf.puppet'
      } else {
        $config_file               = '/etc/redis.conf'
        $config_file_orig          = '/etc/redis.conf.puppet'
      }
      $log_dir                     = '/var/log/redis'
      $package_name                = 'redis'
      $pid_file                    = '/var/run/redis_6379.pid'
      $service_name                = 'redis'
      $workdir                     = '/var/lib/redis'
      $bin_path                    = '/usr/bin'
      if (versioncmp($facts['os']['release']['major'], '9') >= 0) {
        $sentinel_config_file      = '/etc/redis/sentinel.conf'
        $sentinel_config_file_orig = '/etc/redis/sentinel.conf.puppet'
      } else {
        $sentinel_config_file      = '/etc/redis-sentinel.conf'
        $sentinel_config_file_orig = '/etc/redis-sentinel.conf.puppet'
      }
      $sentinel_service_name       = 'redis-sentinel'
      $sentinel_package_name       = 'redis'
      $sentinel_pid_file           = '/var/run/redis/redis-sentinel.pid'
      $sentinel_log_file           = '/var/log/redis/sentinel.log'
    }

    'FreeBSD': {
      $config_dir                = '/usr/local/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/usr/local/etc/redis.conf'
      $config_file_orig          = '/usr/local/etc/redis.conf.puppet'
      $config_group              = 'wheel'
      $config_owner              = 'redis'
      $log_dir                   = '/var/log/redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis.pid'
      $daemonize                 = true
      $service_name              = 'redis'
      $workdir                   = '/var/db/redis'
      $bin_path                  = '/usr/bin'
      $ulimit                    = undef
      $package_ensure            = 'present'
      $appendonly                = 'no'
      $save_db_to_disk           = false

      $sentinel_config_file      = '/usr/local/etc/redis-sentinel.conf'
      $sentinel_config_file_orig = '/usr/local/etc/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_package_name     = 'redis'
      $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
      $sentinel_log_file         = '/var/log/redis/sentinel.log'
      $sentinel_working_dir      = '/tmp'
    }

    'Suse': {
      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0750'
      $config_file               = '/etc/redis/redis-server.conf'
      $config_file_orig          = '/etc/redis/redis-server.conf.puppet'
      $config_group              = 'redis'
      $config_owner              = 'redis'
      $log_dir                   = '/var/log/redis'
      $log_dir_mode              = '0750'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis-server.pid'
      $daemonize                 = true
      $service_name              = 'redis'
      $workdir                   = '/var/lib/redis'
      $bin_path                  = '/usr/bin'
      $ulimit                    = undef
      $package_ensure            = 'present'
      $appendonly                = 'no'
      $save_db_to_disk           = false

      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_package_name     = 'redis'
      $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
      $sentinel_log_file         = '/var/log/redis/sentinel.log'
      $sentinel_working_dir      = '/tmp'
    }

    'Archlinux': {
      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis/redis.conf'
      $config_file_orig          = '/etc/redis/redis.conf.puppet'
      $config_group              = 'root'
      $config_owner              = 'root'
      $log_dir                   = '/var/log/redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis.pid'
      $daemonize                 = true
      $service_name              = 'redis'
      $workdir                   = '/var/lib/redis'
      $bin_path                  = '/usr/bin'
      $ulimit                    = undef
      $package_ensure            = 'present'
      $appendonly                = 'no'
      $save_db_to_disk           = false

      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_package_name     = 'redis'
      $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
      $sentinel_log_file         = '/var/log/redis/sentinel.log'
      $sentinel_working_dir      = '/tmp'
    }
    default: {
      fail "Operating system ${facts['os']['name']} is not supported yet."
    }
  }
}
