# @summary This class provides a number of parameters.
# @api private
class redis::params {
  case $facts['os']['family'] {
    'Debian': {
      $ppa_repo                  = 'ppa:chris-lea/redis-server'

      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis/redis.conf'
      $config_file_orig          = '/etc/redis/redis.conf.puppet'
      $config_owner              = 'redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis-server'
      $pid_file                  = '/var/run/redis/redis-server.pid'
      $workdir                   = '/var/lib/redis'
      $service_group             = 'redis'
      $service_name              = 'redis-server'

      $sentinel_config_file      = '/etc/redis/sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = '/etc/init.d/redis-sentinel'
      $sentinel_package_name     = 'redis-sentinel'

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
      $ppa_repo                  = undef

      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis.conf'
      $config_file_orig          = '/etc/redis.conf.puppet'
      $config_group              = 'root'
      $config_owner              = 'redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis.pid'
      $service_name              = 'redis'
      $workdir                   = '/var/lib/redis'

      $sentinel_config_file      = '/etc/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = false
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'

      # EPEL 6 and newer have 3.2 so we can assume all EL is 3.2+
      $minimum_version           = '3.2.10'

      $service_group = $facts['os']['release']['major'] ? {
        '6'     => 'root',
        default => 'redis',
      }
    }

    'FreeBSD': {
      $ppa_repo                  = undef

      $config_dir                = '/usr/local/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/usr/local/etc/redis.conf'
      $config_file_orig          = '/usr/local/etc/redis.conf.puppet'
      $config_group              = 'wheel'
      $config_owner              = 'redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis.pid'
      $service_group             = 'redis'
      $service_name              = 'redis'
      $workdir                   = '/var/db/redis'

      $sentinel_config_file      = '/usr/local/etc/redis-sentinel.conf'
      $sentinel_config_file_orig = '/usr/local/etc/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'

      # pkg version
      $minimum_version           = '3.2.4'
    }

    'Suse': {
      $ppa_repo                  = undef

      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0750'
      $config_file               = '/etc/redis/redis-server.conf'
      $config_group              = 'redis'
      $config_owner              = 'redis'
      $log_dir_mode              = '0750'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis-server.pid'
      $service_group             = 'redis'
      $service_name              = 'redis'
      $workdir                   = '/var/lib/redis'

      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'

      # suse package version
      $minimum_version           = '3.0.5'
    }

    'Archlinux': {
      $ppa_repo                  = undef

      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0755'
      $config_file               = '/etc/redis/redis.conf'
      $config_file_orig          = '/etc/redis/redis.conf.puppet'
      $config_group              = 'root'
      $config_owner              = 'root'
      $log_dir_mode              = '0755'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis.pid'
      $service_group             = 'redis'
      $service_name              = 'redis'
      $workdir                   = '/var/lib/redis'

      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'

      # pkg version
      $minimum_version           = '3.2.4'
    }
    default: {
      fail "Operating system ${facts['os']['name']} is not supported yet."
    }
  }
}
