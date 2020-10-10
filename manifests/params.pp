# @summary This class provides a number of parameters.
# @api private
class redis::params inherits redis::globals {
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
      $daemonize                 = true
      $service_name              = 'redis-server'

      $sentinel_config_file      = '/etc/redis/sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_init_script      = '/etc/init.d/redis-sentinel'
      $sentinel_package_name     = 'redis-sentinel'
      $sentinel_log_file         = '/var/log/redis/redis-sentinel.log'
      $sentinel_working_dir      = '/var/lib/redis'

      case $facts['os']['name'] {
        'Ubuntu': {
          $config_group = 'redis'
          $minimum_version = $facts['os']['release']['major'] ? {
            '16.04' => '3.0.5',
            '18.04' => '4.0.9',
            default => '5.0.7',
          }
          $sentinel_pid_file = $facts['os']['release']['major'] ? {
            '16.04' => '/var/run/redis/redis-sentinel.pid',
            default => '/var/run/sentinel/redis-sentinel.pid',
          }
        }
        default: {
          $config_group              = 'root'
          $minimum_version           = '3.2.5'
          if versioncmp($facts['os']['release']['major'], '10') >= 0 {
            $sentinel_pid_file         = '/run/sentinel/redis-sentinel.pid'
          } else {
            $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
          }
        }
      }
    }

    'RedHat': {
      $ppa_repo             = undef
      $daemonize            = false
      $config_owner         = 'redis'
      $config_group         = 'root'
      $config_dir_mode      = '0755'
      $log_dir_mode         = '0750'

      $sentinel_daemonize   = false
      $sentinel_init_script = undef
      $sentinel_working_dir = '/tmp'

      $scl = $redis::globals::scl
      if $scl {
        $config_dir                = "/etc/opt/rh/${scl}/redis"
        $config_file               = "/etc/opt/rh/${scl}/redis.conf"
        $config_file_orig          = "/etc/opt/rh/${scl}/redis.conf.puppet"
        $package_name              = "${scl}-redis"
        $pid_file                  = "/var/opt/rh/${scl}/run/redis_6379.pid"
        $service_name              = "${scl}-redis"
        $workdir                   = "/var/opt/rh/${scl}/lib/redis"

        $sentinel_config_file      = "${config_dir}/redis-sentinel.conf"
        $sentinel_config_file_orig = "${config_dir}/redis-sentinel.conf.puppet"
        $sentinel_service_name     = "${scl}-redis-sentinel"
        $sentinel_package_name     = $package_name
        $sentinel_pid_file         = "/var/opt/rh/${scl}/run/redis-sentinel.pid"
        $sentinel_log_file         = "/var/opt/rh/${scl}/log/redis/sentinel.log"

        $minimum_version = $scl ? {
          'rh-redis32' => '3.2.13',
          default      => '5.0.5',
        }
      } else {
        $config_dir                = '/etc/redis'
        $config_file               = '/etc/redis.conf'
        $config_file_orig          = '/etc/redis.conf.puppet'
        $package_name              = 'redis'
        $pid_file                  = $facts['os']['release']['major'] ? {
          '6'     => '/var/run/redis/redis.pid',
          default => '/var/run/redis_6379.pid',
        }
        $service_name              = 'redis'
        $workdir                   = '/var/lib/redis'

        $sentinel_config_file      = '/etc/redis-sentinel.conf'
        $sentinel_config_file_orig = '/etc/redis-sentinel.conf.puppet'
        $sentinel_service_name     = 'redis-sentinel'
        $sentinel_package_name     = 'redis'
        $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
        $sentinel_log_file         = '/var/log/redis/sentinel.log'

        # EPEL 6 and newer have 3.2 so we can assume all EL is 3.2+
        $minimum_version           = '3.2.10'
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
      $daemonize                 = true
      $service_name              = 'redis'
      $workdir                   = '/var/db/redis'

      $sentinel_config_file      = '/usr/local/etc/redis-sentinel.conf'
      $sentinel_config_file_orig = '/usr/local/etc/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'
      $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
      $sentinel_log_file         = '/var/log/redis/sentinel.log'
      $sentinel_working_dir      = '/tmp'

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
      $daemonize                 = true
      $service_name              = 'redis'
      $workdir                   = '/var/lib/redis'

      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'
      $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
      $sentinel_log_file         = '/var/log/redis/sentinel.log'
      $sentinel_working_dir      = '/tmp'

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
      $daemonize                 = true
      $service_name              = 'redis'
      $workdir                   = '/var/lib/redis'

      $sentinel_config_file      = '/etc/redis/redis-sentinel.conf'
      $sentinel_config_file_orig = '/etc/redis/redis-sentinel.conf.puppet'
      $sentinel_service_name     = 'redis-sentinel'
      $sentinel_daemonize        = true
      $sentinel_init_script      = undef
      $sentinel_package_name     = 'redis'
      $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
      $sentinel_log_file         = '/var/log/redis/sentinel.log'
      $sentinel_working_dir      = '/tmp'

      # pkg version
      $minimum_version           = '3.2.4'
    }
    default: {
      fail "Operating system ${facts['os']['name']} is not supported yet."
    }
  }
}
