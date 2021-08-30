# @summary Install redis-sentinel
#
# @param auth_pass
#   The password to use to authenticate with the master and slaves.
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
# @param down_after
#   Number of milliseconds the master (or any attached slave or sentinel)
#   should be unreachable (as in, not acceptable reply to PING, continuously,
#   for the specified period) in order to consider it in S_DOWN state.
#
# @param failover_timeout
#   Specify the failover timeout in milliseconds.
#
# @param log_file
#   Specify where to write log entries.
#
# @param log_level
#   Specify how much we should log.
#
# @param master_name
#   Specify the name of the master redis server.
#   The valid charset is A-z 0-9 and the three characters ".-_".
#
# @param redis_host
#   Specify the bound host of the master redis server.
#
# @param redis_port
#   Specify the port of the master redis server.
#
# @param requirepass
#   Specify the password to require client authentication via the AUTH command, however this feature is only available starting with Redis 5.0.1.
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
# @param parallel_sync
#   How many slaves can be reconfigured at the same time to use a
#   new master after a failover.
#
# @param pid_file
#   If sentinel is daemonized it will write its pid at this location.
#
# @param quorum
#   Number of sentinels that must agree that a master is down to
#   signal sdown state.
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
# @param notification_script
#   Path to the notification script
#
# @param client_reconfig_script
#   Path to the client-reconfig script
#
# @example Basic inclusion
#   include redis::sentinel
#
# @example Configuring options
#   class {'redis::sentinel':
#     down_after => 80000,
#     log_file   => '/var/log/redis/sentinel.log',
#   }
#
class redis::sentinel (
  Optional[Variant[String[1], Sensitive[String[1]]]] $auth_pass = undef,
  Stdlib::Absolutepath $config_file = $redis::params::sentinel_config_file,
  Stdlib::Absolutepath $config_file_orig = $redis::params::sentinel_config_file_orig,
  Stdlib::Filemode $config_file_mode = '0644',
  String[1] $conf_template = 'redis/redis-sentinel.conf.erb',
  Boolean $daemonize = $redis::params::sentinel_daemonize,
  Boolean $protected_mode = true,
  Integer[1] $down_after = 30000,
  Integer[1] $failover_timeout = 180000,
  Redis::LogLevel $log_level = 'notice',
  Stdlib::Absolutepath $log_file = $redis::params::sentinel_log_file,
  String[1] $master_name  = 'mymaster',
  Stdlib::Host $redis_host = '127.0.0.1',
  Stdlib::Port $redis_port = 6379,
  Optional[String[1]] $requirepass = undef,
  String[1] $package_name = $redis::params::sentinel_package_name,
  String[1] $package_ensure = 'installed',
  Integer[0] $parallel_sync = 1,
  Stdlib::Absolutepath $pid_file = $redis::params::sentinel_pid_file,
  Integer[1] $quorum = 2,
  Variant[Undef, Stdlib::IP::Address, Array[Stdlib::IP::Address]] $sentinel_bind = undef,
  Stdlib::Port $sentinel_port = 26379,
  String[1] $service_group = 'redis',
  String[1] $service_name = $redis::params::sentinel_service_name,
  Stdlib::Ensure::Service $service_ensure = 'running',
  Boolean $service_enable = true,
  String[1] $service_user = 'redis',
  Stdlib::Absolutepath $working_dir = $redis::params::sentinel_working_dir,
  Optional[Stdlib::Absolutepath] $notification_script = undef,
  Optional[Stdlib::Absolutepath] $client_reconfig_script = undef,
) inherits redis::params {
  $auth_pass_unsensitive = if $auth_pass =~ Sensitive {
    $auth_pass.unwrap
  } else {
    $auth_pass
  }

  require 'redis'

  ensure_packages([$package_name], {
    ensure => $package_ensure
  })
  Package[$package_name] -> File[$config_file_orig]

  $sentinel_bind_arr = delete_undef_values([$sentinel_bind].flatten)

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
