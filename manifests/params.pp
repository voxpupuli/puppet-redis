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
      $log_dir                   = '/var/log/redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis-server'
      $pid_file                  = '/var/run/redis/redis-server.pid'
      $workdir                   = '/var/lib/redis'
      $bin_path                  = '/usr/bin'
      $daemonize                 = true
      $service_name              = 'redis-server'

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
      $sentinel_working_dir = '/tmp'

      $scl = $redis::globals::scl
      if $scl {
        $config_dir                = "/etc/opt/rh/${scl}"
        $config_file               = "/etc/opt/rh/${scl}/redis.conf"
        $config_file_orig          = "/etc/opt/rh/${scl}/redis.conf.puppet"
        $log_dir                   = "/var/opt/rh/${scl}/log/redis"
        $package_name              = "${scl}-redis"
        $pid_file                  = "/var/opt/rh/${scl}/run/redis_6379.pid"
        $service_name              = "${scl}-redis"
        $workdir                   = "/var/opt/rh/${scl}/lib/redis"
        $bin_path                  = "/opt/rh/${scl}/root/usr/bin"

        $sentinel_config_file      = "${config_dir}/redis-sentinel.conf"
        $sentinel_config_file_orig = "${config_dir}/redis-sentinel.conf.puppet"
        $sentinel_service_name     = "${scl}-redis-sentinel"
        $sentinel_package_name     = $package_name
        $sentinel_pid_file         = "/var/opt/rh/${scl}/run/redis-sentinel.pid"
        $sentinel_log_file         = "/var/opt/rh/${scl}/log/redis/sentinel.log"
      } else {
        $config_dir                = '/etc/redis'
        $config_file               = '/etc/redis.conf'
        $config_file_orig          = '/etc/redis.conf.puppet'
        $log_dir                   = '/var/log/redis'
        $package_name              = 'redis'
        $pid_file                  = '/var/run/redis_6379.pid'
        $service_name              = 'redis'
        $workdir                   = '/var/lib/redis'
        $bin_path                  = '/usr/bin'

        $sentinel_config_file      = '/etc/redis-sentinel.conf'
        $sentinel_config_file_orig = '/etc/redis-sentinel.conf.puppet'
        $sentinel_service_name     = 'redis-sentinel'
        $sentinel_package_name     = 'redis'
        $sentinel_pid_file         = '/var/run/redis/redis-sentinel.pid'
        $sentinel_log_file         = '/var/log/redis/sentinel.log'
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
      $log_dir                   = '/var/log/redis'
      $log_dir_mode              = '0755'
      $package_name              = 'redis'
      $pid_file                  = '/var/run/redis/redis.pid'
      $daemonize                 = true
      $service_name              = 'redis'
      $workdir                   = '/var/db/redis'
      $bin_path                  = '/usr/bin'

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
      $ppa_repo                  = undef

      $config_dir                = '/etc/redis'
      $config_dir_mode           = '0750'
      $config_file               = '/etc/redis/redis-server.conf'
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
      $ppa_repo                  = undef

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
