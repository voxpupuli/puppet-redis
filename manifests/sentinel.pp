# @summary Install redis-sentinel
#
# @param sentinel_monitors
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
# @param daemonize
#   Have Redis sentinel run as a daemon.
#
# @param log_file
#   Specify where to write log entries.
#
# @param log_level
#   Specify how much we should log.
#
# @param protected_mode
#   Whether protected mode is enabled or not. Only applicable when no bind is set.
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
# @example Basic inclusion
#   include redis::sentinel
#
# @example Configuring options
#   class {'redis::sentinel':
#     log_file   => '/var/log/redis/sentinel.log',
#     sentinel_monitors => {
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
  Stdlib::Absolutepath $config_file                = $redis::params::sentinel_config_file,
  Stdlib::Absolutepath $config_file_orig           = $redis::params::sentinel_config_file_orig,
  Stdlib::Filemode $config_file_mode               = '0644',
  String[1] $conf_template                         = 'redis/redis-sentinel.conf.erb',
  Boolean $daemonize                               = $redis::params::sentinel_daemonize,
  Boolean $protected_mode                          = $redis::params::sentinel_protected_mode,
  Redis::LogLevel $log_level                       = 'notice',
  Stdlib::Absolutepath $log_file                   = $redis::params::sentinel_log_file,
  Redis::SentinelMonitors $sentinel_monitors       = $redis::params::sentinel_default_monitor,
  Redis::SentinelMonitorDefaults $monitor_defaults = $redis::params::sentinel_monitor_defaults,
  String[1] $package_name                          = $redis::params::sentinel_package_name,
  String[1] $package_ensure                        = 'present',
  Stdlib::Absolutepath $pid_file                   = $redis::params::sentinel_pid_file,
  Stdlib::Port $sentinel_port                      = 26379,
  String[1] $service_group                         = 'redis',
  String[1] $service_name                          = $redis::params::sentinel_service_name,
  Stdlib::Ensure::Service $service_ensure          = 'running',
  Boolean $service_enable                          = true,
  String[1] $service_user                          = 'redis',
  Stdlib::Absolutepath $working_dir                = $redis::params::sentinel_working_dir,
  Variant[Undef, Stdlib::IP::Address, Array[Stdlib::IP::Address]] $sentinel_bind = undef,
) inherits redis::params {
  require 'redis'

  ensure_packages([$package_name])
  Package[$package_name] -> File[$config_file_orig]

  $sentinel_bind_arr = delete_undef_values([$sentinel_bind].flatten)
  $supports_protected_mode = $redis::supports_protected_mode

  $_monitor = $sentinel_monitors.map |$monitor,$values| {
    $redis_values = $monitor_defaults + { 'monitor_name' => $monitor } + $values
  }

  file { $config_file_orig:
    ensure  => file,
    owner   => $service_user,
    group   => $service_group,
    mode    => $config_file_mode,
    content => template($conf_template),
  }

  exec { "cp -p ${config_file_orig} ${config_file}":
    path        => '/usr/bin:/bin',
    subscribe   => File[$config_file_orig],
    notify      => Service[$service_name],
    refreshonly => true,
  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
