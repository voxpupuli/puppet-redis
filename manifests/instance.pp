# This is an defined type to allow the configuration of
# multiple redis instances on one machine without conflicts
#
# @summary Allows the configuration of multiple redis configurations on one machine
#
# @example
#   redis::instance {'6380':
#     port => 6380,
#   }
#
# @param activerehashing
#   Enable/disable active rehashing.
# @param aof_load_truncated
#   Enable/disable loading truncated AOF file
# @param aof_rewrite_incremental_fsync
#   Enable/disable fsync for AOF file
# @param appendfilename
#   The name of the append only file
# @param appendfsync
#   Adjust fsync mode. Valid options: always, everysec, no.
# @param appendonly
#   Enable/disable appendonly mode.
# @param auto_aof_rewrite_min_size
#   Adjust minimum size for auto-aof-rewrite.
# @param auto_aof_rewrite_percentage
#   Adjust percentatge for auto-aof-rewrite.
# @param bind
#   Configure which IP address(es) to listen on. To bind on all interfaces, use an empty array.
# @param config_file_orig
#   The location and name of a config file that provides the source
# @param config_file
#   Adjust main configuration file.
# @param config_file_mode
#   Adjust permissions for configuration files.
# @param config_group
#   Adjust filesystem group for config files.
# @param config_owner
#   Adjust filesystem owner for config files.
# @param conf_template
#   Define which template to use.
# @param daemonize
#   Have Redis run as a daemon.
# @param databases
#   Set the number of databases.
# @param dbfilename
#   The filename where to dump the DB
# @param extra_config_file
#   Optional extra config file to include
# @param hash_max_ziplist_entries
#   Set max ziplist entries for hashes.
# @param hash_max_ziplist_value
#   Set max ziplist values for hashes.
# @param hll_sparse_max_bytes
#   HyperLogLog sparse representation bytes limit
# @param hz
#   Set redis background tasks frequency
# @param latency_monitor_threshold
#   Latency monitoring threshold in milliseconds
# @param list_max_ziplist_entries
#   Set max ziplist entries for lists.
# @param list_max_ziplist_value
#   Set max ziplist values for lists.
# @param log_dir
#   Specify directory where to write log entries.
# @param log_dir_mode
#   Adjust mode for directory containing log files.
# @param log_file
#   Specify file where to write log entries.
# @param log_level
#   Specify the server verbosity level.
# @param masterauth
#   If the master is password protected (using the "requirepass" configuration
# @param maxclients
#   Set the max number of connected clients at the same time.
# @param maxmemory
#   Don't use more memory than the specified amount of bytes.
# @param maxmemory_policy
#   How Redis will select what to remove when maxmemory is reached.
# @param maxmemory_samples
#   Select as well the sample size to check.
# @param min_slaves_max_lag
#   The lag in seconds
# @param min_slaves_to_write
#   Minimum number of slaves to be in "online" state
# @param no_appendfsync_on_rewrite
#   If you have latency problems turn this to 'true'. Otherwise leave it as
# @param notify_keyspace_events
#   Which events to notify Pub/Sub clients about events happening
# @param pid_file
#   Where to store the pid.
# @param port
#   Configure which port to listen on.
# @param protected_mode
#   Whether protected mode is enabled or not.  Only applicable when no bind is set.
# @param rdbcompression
#   Enable/disable compression of string objects using LZF when dumping.
# @param repl_backlog_size
#   The replication backlog size
# @param repl_backlog_ttl
#   The number of seconds to elapse before freeing backlog buffer
# @param repl_disable_tcp_nodelay
#   Enable/disable TCP_NODELAY on the slave socket after SYNC
# @param repl_ping_slave_period
#   Slaves send PINGs to server in a predefined interval. It's possible
# @param repl_timeout
#   Set the replication timeout for:
# @param requirepass
#   Require clients to issue AUTH <PASSWORD> before processing any other
#   commands.
# @param save_db_to_disk
#   Set if save db to disk.
# @param save_db_to_disk_interval
#   save the dataset every N seconds if there are at least M changes in the dataset
# @param service_name
#   The service name for this instance
# @param service_enable
#   Enable/disable daemon at boot.
# @param service_ensure
#   Specify if the server should be running.
# @param service_group
#   Specify which group to run as.
# @param service_hasrestart
#   Does the init script support restart?
# @param service_hasstatus
#   Does the init script support status?
# @param service_user
#   Specify which user to run as.
# @param set_max_intset_entries
#   The following configuration setting sets the limit in the size of the set
#   in order to use this special memory saving encoding.
# @param slave_priority
#   The priority number for slave promotion by Sentinel
# @param slave_read_only
#   You can configure a slave instance to accept writes or not.
# @param slave_serve_stale_data
#   When a slave loses its connection with the master, or when the replication
#   is still in progress, the slave can act in two different ways:
#   1) if slave-serve-stale-data is set to 'yes' (the default) the slave will
#      still reply to client requests, possibly with out of date data, or the
#      data set may just be empty if this is the first synchronization.
#   2) if slave-serve-stale-data is set to 'no' the slave will reply with
#      an error "SYNC with master in progress" to all the kind of commands
#      but to INFO and SLAVEOF.
# @param slaveof
#   Use slaveof to make a Redis instance a copy of another Redis server.
# @param slowlog_log_slower_than
#   Tells Redis what is the execution time, in microseconds, to exceed in order
#   for the command to get logged.
# @param slowlog_max_len
#   Tells Redis what is the length to exceed in order for the command
#   to get logged.
# @param stop_writes_on_bgsave_error
#   If false then Redis will continue to work as usual even if there
#   are problems with disk, permissions, and so forth.
# @param syslog_enabled
#   Enable/disable logging to the system logger.
# @param syslog_facility
#   Specify the syslog facility. Must be USER or between LOCAL0-LOCAL7.
# @param tcp_backlog
#   Sets the TCP backlog
# @param tcp_keepalive
#   TCP keepalive.
# @param timeout
#   Close the connection after a client is idle for N seconds (0 to disable).
# @param ulimit
#   Limit the use of system-wide resources.
# @param unixsocket
#   Define unix socket path
# @param unixsocketperm
#   Define unix socket file permissions
# @param workdir
#   The DB will be written inside this directory, with the filename specified
#   above using the 'dbfilename' configuration directive.
# @param workdir_mode
#   Adjust mode for data directory.
# @param zset_max_ziplist_entries
#   Set max entries for sorted sets.
# @param zset_max_ziplist_value
#   Set max values for sorted sets.
# @param cluster_enabled
#   Enables redis 3.0 cluster functionality
# @param cluster_config_file
#   Config file for saving cluster nodes configuration. This file is never
#   touched by humans.  Only set if cluster_enabled is true
# @param cluster_node_timeout
#   Node timeout. Only set if cluster_enabled is true
# @param cluster_slave_validity_factor
#   Control variable to disable promoting slave in case of disconnection from
#   master Only set if cluster_enabled is true
# @param cluster_require_full_coverage
#   If false Redis Cluster will server queries even if requests about a subset
#   of keys can be processed Only set if cluster_enabled is true
# @param cluster_migration_barrier
#   Minimum number of slaves master will remain connected with, for another
#   slave to migrate to a  master which is no longer covered by any slave Only
#   set if cluster_enabled is true
define redis::instance (
  Boolean $activerehashing                                       = $redis::activerehashing,
  Boolean $aof_load_truncated                                    = $redis::aof_load_truncated,
  Boolean $aof_rewrite_incremental_fsync                         = $redis::aof_rewrite_incremental_fsync,
  String[1] $appendfilename                                      = $redis::appendfilename,
  Enum['no', 'always', 'everysec'] $appendfsync                  = $redis::appendfsync,
  Boolean $appendonly                                            = $redis::appendonly,
  String[1] $auto_aof_rewrite_min_size                           = $redis::auto_aof_rewrite_min_size,
  Integer[0] $auto_aof_rewrite_percentage                        = $redis::auto_aof_rewrite_percentage,
  Variant[Stdlib::IP::Address, Array[Stdlib::IP::Address]] $bind = $redis::bind,
  String[1] $output_buffer_limit_slave                           = $redis::output_buffer_limit_slave,
  String[1] $output_buffer_limit_pubsub                          = $redis::output_buffer_limit_pubsub,
  String[1] $conf_template                                       = $redis::conf_template,
  Stdlib::Absolutepath $config_file                              = $redis::config_file,
  Stdlib::Filemode $config_file_mode                             = $redis::config_file_mode,
  Stdlib::Absolutepath $config_file_orig                         = $redis::config_file_orig,
  String[1] $config_group                                        = $redis::config_group,
  String[1] $config_owner                                        = $redis::config_owner,
  Boolean $daemonize                                             = true,
  Integer[1] $databases                                          = $redis::databases,
  Variant[String[1], Boolean] $dbfilename                        = $redis::dbfilename,
  Optional[String] $extra_config_file                            = $redis::extra_config_file,
  Integer[0] $hash_max_ziplist_entries                           = $redis::hash_max_ziplist_entries,
  Integer[0] $hash_max_ziplist_value                             = $redis::hash_max_ziplist_value,
  Integer[0] $hll_sparse_max_bytes                               = $redis::hll_sparse_max_bytes,
  Integer[1, 500] $hz                                            = $redis::hz,
  Integer[0] $latency_monitor_threshold                          = $redis::latency_monitor_threshold,
  Integer[0] $list_max_ziplist_entries                           = $redis::list_max_ziplist_entries,
  Integer[0] $list_max_ziplist_value                             = $redis::list_max_ziplist_value,
  Stdlib::Absolutepath $log_dir                                  = $redis::log_dir,
  Stdlib::Filemode $log_dir_mode                                 = $redis::log_dir_mode,
  Redis::LogLevel $log_level                                     = $redis::log_level,
  String[1] $minimum_version                                     = $redis::minimum_version,
  Optional[String[1]] $masterauth                                = $redis::masterauth,
  Integer[1] $maxclients                                         = $redis::maxclients,
  $maxmemory                                                     = $redis::maxmemory,
  $maxmemory_policy                                              = $redis::maxmemory_policy,
  $maxmemory_samples                                             = $redis::maxmemory_samples,
  Integer[0] $min_slaves_max_lag                                 = $redis::min_slaves_max_lag,
  Integer[0] $min_slaves_to_write                                = $redis::min_slaves_to_write,
  Boolean $no_appendfsync_on_rewrite                             = $redis::no_appendfsync_on_rewrite,
  Optional[String[1]] $notify_keyspace_events                    = $redis::notify_keyspace_events,
  Boolean $managed_by_cluster_manager                            = $redis::managed_by_cluster_manager,
  String[1] $package_ensure                                      = $redis::package_ensure,
  Stdlib::Port $port                                             = $redis::port,
  Boolean $protected_mode                                        = $redis::protected_mode,
  Boolean $rdbcompression                                        = $redis::rdbcompression,
  String[1] $repl_backlog_size                                   = $redis::repl_backlog_size,
  Integer[0] $repl_backlog_ttl                                   = $redis::repl_backlog_ttl,
  Boolean $repl_disable_tcp_nodelay                              = $redis::repl_disable_tcp_nodelay,
  Integer[1] $repl_ping_slave_period                             = $redis::repl_ping_slave_period,
  Integer[1] $repl_timeout                                       = $redis::repl_timeout,
  Optional[String] $requirepass                                  = $redis::requirepass,
  Boolean $save_db_to_disk                                       = $redis::save_db_to_disk,
  Hash $save_db_to_disk_interval                                 = $redis::save_db_to_disk_interval,
  String[1] $service_user                                        = $redis::service_user,
  Integer[0] $set_max_intset_entries                             = $redis::set_max_intset_entries,
  Integer[0] $slave_priority                                     = $redis::slave_priority,
  Boolean $slave_read_only                                       = $redis::slave_read_only,
  Boolean $slave_serve_stale_data                                = $redis::slave_serve_stale_data,
  Optional[String[1]] $slaveof                                   = $redis::slaveof,
  Integer[0] $slowlog_log_slower_than                            = $redis::slowlog_log_slower_than,
  Integer[0] $slowlog_max_len                                    = $redis::slowlog_max_len,
  Boolean $stop_writes_on_bgsave_error                           = $redis::stop_writes_on_bgsave_error,
  Boolean $syslog_enabled                                        = $redis::syslog_enabled,
  Optional[String[1]] $syslog_facility                           = $redis::syslog_facility,
  Integer[0] $tcp_backlog                                        = $redis::tcp_backlog,
  Integer[0] $tcp_keepalive                                      = $redis::tcp_keepalive,
  Integer[0] $timeout                                            = $redis::timeout,
  Variant[Stdlib::Filemode , Enum['']] $unixsocketperm           = $redis::unixsocketperm,
  Integer[0] $ulimit                                             = $redis::ulimit,
  Stdlib::Filemode $workdir_mode                                 = $redis::workdir_mode,
  Integer[0] $zset_max_ziplist_entries                           = $redis::zset_max_ziplist_entries,
  Integer[0] $zset_max_ziplist_value                             = $redis::zset_max_ziplist_value,
  Boolean $cluster_enabled                                       = $redis::cluster_enabled,
  String[1] $cluster_config_file                                 = $redis::cluster_config_file,
  Integer[1] $cluster_node_timeout                               = $redis::cluster_node_timeout,
  Integer[0] $cluster_slave_validity_factor                      = $redis::cluster_slave_validity_factor,
  Boolean $cluster_require_full_coverage                         = $redis::cluster_require_full_coverage,
  Integer[0] $cluster_migration_barrier                          = $redis::cluster_migration_barrier,
  String[1] $service_name                                        = "redis-server-${name}",
  Stdlib::Ensure::Service $service_ensure                        = $redis::service_ensure,
  Boolean $service_enable                                        = $redis::service_enable,
  String[1] $service_group                                       = $redis::service_group,
  Boolean $service_hasrestart                                    = $redis::service_hasrestart,
  Boolean $service_hasstatus                                     = $redis::service_hasstatus,
  Boolean $manage_service_file                                   = true,
  Optional[Stdlib::Absolutepath] $log_file                       = undef,
  Stdlib::Absolutepath $pid_file                                 = "/var/run/redis/redis-server-${name}.pid",
  Variant[Stdlib::Absolutepath, Enum['']] $unixsocket            = "/var/run/redis/redis-server-${name}.sock",
  Stdlib::Absolutepath $workdir                                  = "${redis::workdir}/redis-server-${name}",
) {
  if $title == 'default' {
    $redis_file_name_orig = $config_file_orig
    $redis_file_name      = $config_file
  } else {
    $redis_file_name_orig = sprintf('%s/%s.%s', dirname($config_file_orig), $service_name, 'conf.puppet')
    $redis_file_name      = sprintf('%s/%s.%s', dirname($config_file), $service_name, 'conf')
  }

  if $log_dir != $redis::log_dir {
    file { $log_dir:
      ensure => directory,
      group  => $service_group,
      mode   => $log_dir_mode,
      owner  => $service_user,
    }
  }

  $_real_log_file = $log_file ? {
    undef   => "${log_dir}/redis-server-${name}.log",
    default => $log_file,
  }

  if $workdir != $redis::workdir {
    file { $workdir:
      ensure => directory,
      group  => $service_group,
      mode   => $workdir_mode,
      owner  => $service_user,
    }
  }

  if $manage_service_file {
    $service_provider_lookup = pick(getvar('service_provider'), false)

    if $service_provider_lookup == 'systemd' {
      file { "/etc/systemd/system/${service_name}.service":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('redis/service_templates/redis.service.erb'),
      }

      # Only necessary for Puppet < 6.1.0,
      # See https://github.com/puppetlabs/puppet/commit/f8d5c60ddb130c6429ff12736bfdb4ae669a9fd4
      if versioncmp($facts['puppetversion'],'6.1.0') < 0 {
        include systemd::systemctl::daemon_reload
        File["/etc/systemd/system/${service_name}.service"] ~> Class['systemd::systemctl::daemon_reload']
      }

      if $title != 'default' {
        service { $service_name:
          ensure     => $service_ensure,
          enable     => $service_enable,
          hasrestart => $service_hasrestart,
          hasstatus  => $service_hasstatus,
          subscribe  => [
            File["/etc/systemd/system/${service_name}.service"],
            Exec["cp -p ${redis_file_name_orig} ${redis_file_name}"],
          ],
        }
      }
    } else {
      file { "/etc/init.d/${service_name}":
        ensure  => file,
        mode    => '0755',
        content => template("redis/service_templates/redis.${facts['os']['family']}.erb"),
      }

      if $title != 'default' {
        service { $service_name:
          ensure     => $service_ensure,
          enable     => $service_enable,
          hasrestart => $service_hasrestart,
          hasstatus  => $service_hasstatus,
          subscribe  => [
            File["/etc/init.d/${service_name}"],
            Exec["cp -p ${redis_file_name_orig} ${redis_file_name}"],
          ],
        }
      }
    }
  }

  File {
    owner  => $config_owner,
    group  => $config_group,
    mode   => $config_file_mode,
  }

  file { $redis_file_name_orig:
    ensure  => file,
  }

  exec { "cp -p ${redis_file_name_orig} ${redis_file_name}":
    path        => '/usr/bin:/bin',
    subscribe   => File[$redis_file_name_orig],
    refreshonly => true,
  }

  $bind_arr = [$bind].flatten

  if $package_ensure =~ /^([0-9]+:)?[0-9]+\.[0-9]/ {
    if ':' in $package_ensure {
      $_redis_version_real = split($package_ensure, ':')
      $redis_version_real = $_redis_version_real[1]
    } else {
      $redis_version_real = $package_ensure
    }
  } else {
    $redis_version_real = pick(getvar('redis_server_version'), $minimum_version)
  }

  $supports_protected_mode = !$redis_version_real or versioncmp($redis_version_real, '3.2.0') >= 0

  File[$redis_file_name_orig] { content => template($conf_template) }
}
