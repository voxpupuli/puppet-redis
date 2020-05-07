# @summary Install redis-sentinel
#
# @param sentinel_monitor
#   Specify the sentinel monitor.
#
# @param monitor_defaults
#   Override the monitor defaults
#
# @param config_file
#   The location and name of the sentinel config file.
#
# @param config_file_orig
#   The location and name of a config file that provides the source
#   of the sentinel config file. Two different files are needed
#   because sentinel itself writes to its own config file and we do
#   not want override that when puppet is run unless there are
#   changes from the manifests.
#
# @param config_file_mode
#   Permissions of config file.
#
# @param conf_template
#   Define which template to use.
#
# @param init_script
#   Specifiy the init script that will be created for sentinel.
#
# @param log_file
#   Specify where to write log entries.
#
# @param log_level
#   Specify how much we should log.
#
# @param package_name
#   The name of the package that installs sentinel.
#
# @param package_ensure
#   Do we ensure this package.
#
# @param pid_file
#   If sentinel is daemonized it will write its pid at this location.
#
# @param sentinel_bind
#   Allow optional sentinel server ip binding.  Can help overcome
#   issues arising from protect-mode added Redis 3.2
#
# @param sentinel_port
#   The port of sentinel server.
#
# @param service_group
#   The group of the config file.
#
# @param service_name
#   The name of the service (for puppet to manage).
#
# @param service_user
#   The owner of the config file.
#
# @param service_enable
#   Enable the service at boot time.
#
# @param working_dir
#   The directory into which sentinel will change to avoid mount
#   conflicts.
#
# @example Configuring options
#   class {'redis::sentinel':
#     log_file   => '/var/log/redis/sentinel.log',    
#     sentinel_monitor => {
#       'session' => {
#         redis_host       => $redis_master_ip,
#         redis_port       => 6381,
#         quorum           => 2,
#         parallel_sync    => 1,
#         down_after       => 5000,
#         failover_timeout => 12000,
#         auth_pass        => $redis_auth,
#       },
#       'cache'   => {
#         redis_host       => $redis_master_ip,
#         redis_port       => 6380,
#         quorum           => 2,
#         parallel_sync    => 1,
#         down_after       => 5000,
#         failover_timeout => 12000,
#         auth_pass        => $redis_auth,
#       }
#     }
#
class redis::sentinel (
  Stdlib::Absolutepath $config_file           = $redis::params::sentinel_config_file,
  Stdlib::Absolutepath $config_file_orig      = $redis::params::sentinel_config_file_orig,
  Stdlib::Filemode $config_file_mode          = '0644',
  String[1] $conf_template                    = 'redis/redis-sentinel.conf.erb',
  Boolean $daemonize                          = $redis::params::sentinel_daemonize,
  Optional[Stdlib::Absolutepath] $init_script = $redis::params::sentinel_init_script,
  String[1] $init_template                    = 'redis/redis-sentinel.init.erb',
  Redis::LogLevel $log_level                  = 'notice',
  Stdlib::Absolutepath $log_file              = $redis::params::sentinel_log_file,
  Redis::SentinelMonitor $sentinel_monitor    = $redis::params::sentinel_default_monitor,
  $monitor_defaults                           = $redis::params::sentinel_monitor_defaults,
  String[1] $package_name                     = $redis::params::sentinel_package_name,
  String[1] $package_ensure                   = 'present',
  Integer[0] $parallel_sync                   = 1,
  Stdlib::Absolutepath $pid_file              = $redis::params::sentinel_pid_file,
  Stdlib::Port $sentinel_port                 = 26379,
  String[1] $service_group                    = 'redis',
  String[1] $service_name                     = $redis::params::sentinel_service_name,
  Stdlib::Ensure::Service $service_ensure     = 'running',
  Boolean $service_enable                     = true,
  String[1] $service_user                     = 'redis',
  Stdlib::Absolutepath $working_dir           = $redis::params::sentinel_working_dir,
  Variant[Undef, Stdlib::IP::Address, Array[Stdlib::IP::Address]] $sentinel_bind = undef,
) inherits redis::params {

  require 'redis'

  if $facts['os']['family'] == 'Debian' {
    package { $package_name:
      ensure => $package_ensure,
      before => Concat[$config_file_orig],
    }

    if $init_script {
      Package[$package_name] -> File[$init_script]
    }
  }

  Concat {
    owner => $service_user,
    group => $service_group,
    mode  => $config_file_mode,
  }

  concat { $config_file_orig:
    ensure => present,
  }

  concat::fragment { 'sentinel_conf_header':
    target  => $config_file_orig,
    order   => 10,
    content => template('redis/sentinel/redis-sentinel.conf_header.erb'),
  }

  $sentinel_monitor.each |$monitor,$values| {
    $_monitor = merge($monitor_defaults,$values)
    $redis_values = merge({'monitor_name' => $monitor},$_monitor)
    concat::fragment { "sentinel_conf_monitor_${monitor}" :
      target  => $config_file_orig,
      order   => 20,
      content => epp('redis/sentinel/redis-sentinel.conf_monitor.epp', {
        monitor_name           => $redis_values['monitor_name'],
        redis_host             => $redis_values['redis_host'],
        redis_port             => $redis_values['redis_port'],
        quorum                 => $redis_values['quorum'],
        down_after             => $redis_values['down_after'],
        parallel_sync          => $redis_values['parallel_sync'],
        failover_timeout       => $redis_values['failover_timeout'],
        auth_pass              => $redis_values['auth_pass'],
        notification_script    => $redis_values['notification_script'],
        client_reconfig_script => $redis_values['client_reconfig_script'],
      }),
    }
  }

  concat::fragment { 'sentinel_conf_footer':
    target  => $config_file_orig,
    order   => 30,
    content => template('redis/sentinel/redis-sentinel.conf_footer.erb'),
  }

  exec { "cp -p ${config_file_orig} ${config_file}":
    path        => '/usr/bin:/bin',
    subscribe   => Concat[$config_file_orig],
    notify      => Service[$service_name],
    refreshonly => true,
  }

  if $init_script {

    file { $init_script:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template($init_template),
    }

    exec { '/usr/sbin/update-rc.d redis-sentinel defaults':
      subscribe   => File[$init_script],
      refreshonly => true,
      notify      => Service[$service_name],
    }

  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }

}
