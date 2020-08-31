# This class installs redis
#
# @example Default install
#   include redis
#
# @example Slave Node
#   class { '::redis':
#     bind    => '10.0.1.2',
#     slaveof => '10.0.1.1 6379',
#   }
#
# @example Binding on multiple interfaces
#   class { 'redis':
#     bind => ['127.0.0.1', '10.0.0.1', '10.1.0.1'],
#   }
#
# @example Binding on all interfaces
#   class { 'redis':
#     bind => [],
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
#   Adjust fsync mode
# @param appendonly
#   Enable/disable appendonly mode.
# @param auto_aof_rewrite_min_size
#   Adjust minimum size for auto-aof-rewrite.
# @param auto_aof_rewrite_percentage
#   Adjust percentatge for auto-aof-rewrite.
# @param bind
#   Configure which IP address(es) to listen on. To bind on all interfaces, use an empty array.
# @param config_dir
#   Directory containing the configuration files.
# @param config_dir_mode
#   Adjust mode for directory containing configuration files.
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
# @param default_install
#   Configure a default install of redis.
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
# @param manage_repo
#   Enable/disable upstream repository configuration.
# @param manage_package
#   Enable/disable management of package
# @param managed_by_cluster_manager
#   Choose if redis will be managed by a cluster manager such as pacemaker or rgmanager
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
# @param notify_service
#   You may disable service reloads when config files change if you
# @param package_ensure
#   Default action for package.
# @param package_name
#   Upstream package name.
# @param pid_file
#   Where to store the pid.
# @param port
#   Configure which port to listen on.
# @param protected_mode
#   Whether protected mode is enabled or not.  Only applicable when no bind is set.
# @param ppa_repo
#   Specify upstream (Ubuntu) PPA entry.
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
#   Require clients to issue AUTH <PASSWORD> before processing any other commands.
# @param save_db_to_disk
#   Set if save db to disk.
# @param save_db_to_disk_interval
#   save the dataset every N seconds if there are at least M changes in the dataset
# @param service_manage
#   Specify if the service should be part of the catalog.
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
# @param service_name
#   Specify the service name for Init or Systemd.
# @param service_provider
#   Specify the service provider to use
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
#   Tells Redis what is the length to exceed in order for the command to get
#   logged.
# @param stop_writes_on_bgsave_error
#   If false then Redis will continue to work as usual even if there are
#   problems with disk, permissions, and so forth.
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
#   touched by humans. Only set if cluster_enabled is true
# @param cluster_node_timeout
#   Node timeout. Only set if cluster_enabled is true
# @param cluster_slave_validity_factor
#   Control variable to disable promoting slave in case of disconnection from master
#   Only set if cluster_enabled is true
# @param cluster_require_full_coverage
#   If false Redis Cluster will server queries even if requests about a subset of keys can be processed
#   Only set if cluster_enabled is true
# @param cluster_migration_barrier
#   Minimum number of slaves master will remain connected with, for another
#   slave to migrate to a master which is no longer covered by any slave.
#   Only set if cluster_enabled is true
# @param instances
#   Iterate through multiple instance configurations
class redis (
  Boolean $activerehashing                                       = true,
  Boolean $aof_load_truncated                                    = true,
  Boolean $aof_rewrite_incremental_fsync                         = true,
  String[1] $appendfilename                                      = 'appendonly.aof',
  Enum['no', 'always', 'everysec'] $appendfsync                  = 'everysec',
  Boolean $appendonly                                            = false,
  String[1] $auto_aof_rewrite_min_size                           = '64mb',
  Integer[0] $auto_aof_rewrite_percentage                        = 100,
  Variant[Stdlib::IP::Address, Array[Stdlib::IP::Address]] $bind = ['127.0.0.1'],
  String[1] $output_buffer_limit_slave                           = '256mb 64mb 60',
  String[1] $output_buffer_limit_pubsub                          = '32mb 8mb 60',
  String[1] $conf_template                                       = 'redis/redis.conf.erb',
  Stdlib::Absolutepath $config_dir                               = $redis::params::config_dir,
  Stdlib::Filemode $config_dir_mode                              = $redis::params::config_dir_mode,
  Stdlib::Absolutepath $config_file                              = $redis::params::config_file,
  Stdlib::Filemode $config_file_mode                             = '0644',
  Stdlib::Absolutepath $config_file_orig                         = $redis::params::config_file_orig,
  String[1] $config_group                                        = $redis::params::config_group,
  String[1] $config_owner                                        = $redis::params::config_owner,
  Boolean $daemonize                                             = $redis::params::daemonize,
  Integer[1] $databases                                          = 16,
  Boolean $default_install                                       = true,
  Variant[String[1], Boolean] $dbfilename                        = 'dump.rdb',
  Optional[String] $extra_config_file                            = undef,
  Integer[0] $hash_max_ziplist_entries                           = 512,
  Integer[0] $hash_max_ziplist_value                             = 64,
  Integer[0] $hll_sparse_max_bytes                               = 3000,
  Integer[1, 500] $hz                                            = 10,
  Integer[0] $latency_monitor_threshold                          = 0,
  Integer[0] $list_max_ziplist_entries                           = 512,
  Integer[0] $list_max_ziplist_value                             = 64,
  Stdlib::Absolutepath $log_dir                                  = '/var/log/redis',
  Stdlib::Filemode $log_dir_mode                                 = $redis::params::log_dir_mode,
  Stdlib::Absolutepath $log_file                                 = '/var/log/redis/redis.log',
  Redis::LogLevel $log_level                                     = 'notice',
  Boolean $manage_service_file                                   = false,
  Boolean $manage_package                                        = true,
  Boolean $manage_repo                                           = false,
  Optional[String[1]] $masterauth                                = undef,
  Integer[1] $maxclients                                         = 10000,
  $maxmemory                                                     = undef,
  $maxmemory_policy                                              = undef,
  $maxmemory_samples                                             = undef,
  Integer[0] $min_slaves_max_lag                                 = 10,
  Integer[0] $min_slaves_to_write                                = 0,
  Boolean $no_appendfsync_on_rewrite                             = false,
  Optional[String[1]] $notify_keyspace_events                    = undef,
  Boolean $notify_service                                        = true,
  Boolean $managed_by_cluster_manager                            = false,
  String[1] $package_ensure                                      = 'present',
  String[1] $package_name                                        = $redis::params::package_name,
  Stdlib::Absolutepath $pid_file                                 = $redis::params::pid_file,
  Stdlib::Port $port                                             = 6379,
  Boolean $protected_mode                                        = true,
  Optional[String] $ppa_repo                                     = $redis::params::ppa_repo,
  Boolean $rdbcompression                                        = true,
  String[1] $repl_backlog_size                                   = '1mb',
  Integer[0] $repl_backlog_ttl                                   = 3600,
  Boolean $repl_disable_tcp_nodelay                              = false,
  Integer[1] $repl_ping_slave_period                             = 10,
  Integer[1] $repl_timeout                                       = 60,
  Optional[String] $requirepass                                  = undef,
  Boolean $save_db_to_disk                                       = true,
  Hash $save_db_to_disk_interval                                 = { '900' => '1', '300' => '10', '60' => '10000' },
  Boolean $service_enable                                        = true,
  Stdlib::Ensure::Service $service_ensure                        = 'running',
  String[1] $service_group                                       = 'redis',
  Boolean $service_hasrestart                                    = true,
  Boolean $service_hasstatus                                     = true,
  Boolean $service_manage                                        = true,
  String[1] $service_name                                        = $redis::params::service_name,
  Optional[String] $service_provider                             = undef,
  String[1] $service_user                                        = 'redis',
  Integer[0] $set_max_intset_entries                             = 512,
  Integer[0] $slave_priority                                     = 100,
  Boolean $slave_read_only                                       = true,
  Boolean $slave_serve_stale_data                                = true,
  Optional[String[1]] $slaveof                                   = undef,
  Integer[0] $slowlog_log_slower_than                            = 10000,
  Integer[0] $slowlog_max_len                                    = 1024,
  Boolean $stop_writes_on_bgsave_error                           = true,
  Boolean $syslog_enabled                                        = false,
  Optional[String[1]] $syslog_facility                           = undef,
  Integer[0] $tcp_backlog                                        = 511,
  Integer[0] $tcp_keepalive                                      = 0,
  Integer[0] $timeout                                            = 0,
  Variant[Stdlib::Absolutepath, Enum['']] $unixsocket            = '/var/run/redis/redis.sock',
  Variant[Stdlib::Filemode, Enum['']] $unixsocketperm            = '0755',
  Integer[0] $ulimit                                             = 65536,
  Stdlib::Absolutepath $workdir                                  = $redis::params::workdir,
  Stdlib::Filemode $workdir_mode                                 = '0750',
  Integer[0] $zset_max_ziplist_entries                           = 128,
  Integer[0] $zset_max_ziplist_value                             = 64,
  Boolean $cluster_enabled                                       = false,
  String[1] $cluster_config_file                                 = 'nodes.conf',
  Integer[1] $cluster_node_timeout                               = 5000,
  Integer[0] $cluster_slave_validity_factor                      = 0,
  Boolean $cluster_require_full_coverage                         = true,
  Integer[0] $cluster_migration_barrier                          = 1,
  Hash[String[1], Hash] $instances                               = {},
) inherits redis::params {
  contain redis::preinstall
  contain redis::install
  contain redis::config
  contain redis::service

  $instances.each | String $key, Hash $values | {
    redis::instance { $key:
      * => $values,
    }
  }

  Class['redis::preinstall']
  -> Class['redis::install']
  -> Class['redis::config']

  if $redis::notify_service {
    Class['redis::config']
    ~> Class['redis::service']
  }
}
