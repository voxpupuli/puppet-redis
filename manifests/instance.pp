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
#   Specify file where to write log entries. Relative paths will be prepended
#   with log_dir but absolute paths are also accepted.
# @param log_level
#   Specify the server verbosity level.
# @param managed_by_cluster_manager
#   Choose if redis will be managed by a cluster manager such as pacemaker or rgmanager
# @param manage_service_file
#   Determine if the systemd service file should be managed
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
# @param modules
#   Additional redis modules to load (.so path)
# @param no_appendfsync_on_rewrite
#   If you have latency problems turn this to 'true'. Otherwise leave it as
# @param notify_keyspace_events
#   Which events to notify Pub/Sub clients about events happening
# @param notify_service
#   You may disable instance service reloads when config file changes
# @param pid_file
#   Where to store the pid.
# @param port
#   Configure which port to listen on.
# @param protected_mode
#   Whether protected mode is enabled or not.  Only applicable when no bind is set.
# @param rdbcompression
#   Enable/disable compression of string objects using LZF when dumping.
# @param rename_commands
#   A list of Redis commands to rename or disable for security reasons
# @param repl_announce_ip
#   The specific IP or hostname a replica will report to its master
# @param repl_announce_port
#   The specific port a replica will report to its master
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
# @param service_user
#   Specify which user to run as.
# @param service_timeout_start
#   Specify the time after which a service startup should be considered as failed.
# @param service_timeout_stop
#   Specify the time after which a service stop should be considered as failed.
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
# @param replicaof
#   Use replicaof to make a Redis instance a copy of another Redis server.
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
# @param tls_port
#   Configure which TLS port to listen on.
# @param tls_cert_file
#   Specify which X.509 certificate file to use for TLS connections.
# @param tls_key_file
#   Specify which privaye key file to use for TLS connections.
# @param tls_ca_cert_file
#   Specify which X.509 CA certificate(s) bundle file to use.
# @param tls_ca_cert_dir
#   Specify which X.509 CA certificate(s) bundle directory to use.
# @param tls_auth_clients
#   Specify if clients and replicas are required to authenticate using valid client side certificates.
# @param tls_replication
#   Specify if TLS should be enabled on replication links.
# @param tls_cluster
#   Specify if TLS should be used for the bus protocol.
# @param tls_ciphers
#   Configure allowed ciphers for TLS <= TLSv1.2.
# @param tls_ciphersuites
#   Configure allowed TLSv1.3 ciphersuites.
# @param tls_protocols
#   Configure allowed TLS protocol versions.
# @param tls_prefer_server_ciphers
#   Specify if the server's preference should be used when choosing a cipher.
# @param ulimit
#   Limit the use of system-wide resources.
# @param ulimit_managed
#   Defines wheter the max number of open files for the
#   systemd service unit is explicitly managed.
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
# @param io_threads
#   Number of threads to handle IO operations in Redis
# @param io_threads_do_reads
#   Enabled/disable io_threads to handle reads
# @param cluster_allow_reads_when_down
#   Allows nodes to serve read data while cluster status is down
# @param cluster_replica_no_failover
#   Disabled automatic failover for replica
# @param dynamic_hz
#   When dynamic HZ is enabled, the actual configured HZ will be used
#   as a baseline, but multiples of the configured HZ value will be actually
#   used as needed once more clients are connected.
# @param activedefrag
#   Enable/disable active defragmentation
# @param active_defrag_ignore_bytes
#   Minimum amount of fragmentation waste to start active defrag
#   Only set if activedefrag is true
# @param active_defrag_threshold_lower
#   Minimum percentage of fragmentation to start active defrag
#   Only set if activedefrag is true
# @param active_defrag_threshold_upper
#   Maximum percentage of fragmentation at which we use maximum effort
#   Only set if activedefrag is true
# @param active_defrag_cycle_min
#   Minimal effort for defrag in CPU percentage, to be used when the lower
#   threshold is reached
#   Only set if activedefrag is true
# @param active_defrag_cycle_max
#   Maximal effort for defrag in CPU percentage, to be used when the upper
#   threshold is reached
#   Only set if activedefrag is true
# @param active_defrag_max_scan_fields
#   Maximum number of set/hash/zset/list fields that will be processed from
#   the main dictionary scan
#   Only set if activedefrag is true
# @param jemalloc_bg_thread
#   Jemalloc background thread for purging will be enabled by default
# @param rdb_save_incremental_fsync
#   When redis saves RDB file, if the following option is enabled
#   the file will be fsync-ed every 32 MB of data generated.
# @param output_buffer_limit_slave
#   Value of client-output-buffer-limit-slave in redis config
# @param output_buffer_limit_pubsub
#   Value of client-output-buffer-limit-pubsub in redis config
#
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
  Optional[Variant[String[1], Sensitive[String[1]], Deferred]] $masterauth = $redis::masterauth,
  Integer[1] $maxclients                                         = $redis::maxclients,
  Optional[Variant[Integer, String]] $maxmemory                  = $redis::maxmemory,
  Optional[Redis::MemoryPolicy] $maxmemory_policy                = $redis::maxmemory_policy,
  Optional[Integer[1, 10]] $maxmemory_samples                    = $redis::maxmemory_samples,
  Integer[0] $min_slaves_max_lag                                 = $redis::min_slaves_max_lag,
  Integer[0] $min_slaves_to_write                                = $redis::min_slaves_to_write,
  Array[Stdlib::Absolutepath] $modules                           = $redis::modules,
  Boolean $no_appendfsync_on_rewrite                             = $redis::no_appendfsync_on_rewrite,
  Optional[String[1]] $notify_keyspace_events                    = $redis::notify_keyspace_events,
  Boolean $notify_service                                        = true,
  Boolean $managed_by_cluster_manager                            = $redis::managed_by_cluster_manager,
  Stdlib::Port $port                                             = $redis::port,
  Boolean $protected_mode                                        = $redis::protected_mode,
  Boolean $rdbcompression                                        = $redis::rdbcompression,
  Hash[String,String] $rename_commands                           = $redis::rename_commands,
  Optional[Stdlib::Host] $repl_announce_ip                       = $redis::repl_announce_ip,
  Optional[Stdlib::Port] $repl_announce_port                     = $redis::repl_announce_port,
  String[1] $repl_backlog_size                                   = $redis::repl_backlog_size,
  Integer[0] $repl_backlog_ttl                                   = $redis::repl_backlog_ttl,
  Boolean $repl_disable_tcp_nodelay                              = $redis::repl_disable_tcp_nodelay,
  Integer[1] $repl_ping_slave_period                             = $redis::repl_ping_slave_period,
  Integer[1] $repl_timeout                                       = $redis::repl_timeout,
  Optional[Variant[String, Deferred]] $requirepass               = $redis::requirepass,
  Boolean $save_db_to_disk                                       = $redis::save_db_to_disk,
  Hash $save_db_to_disk_interval                                 = $redis::save_db_to_disk_interval,
  String[1] $service_user                                        = $redis::service_user,
  Integer[0] $set_max_intset_entries                             = $redis::set_max_intset_entries,
  Integer[0] $slave_priority                                     = $redis::slave_priority,
  Boolean $slave_read_only                                       = $redis::slave_read_only,
  Boolean $slave_serve_stale_data                                = $redis::slave_serve_stale_data,
  Optional[String[1]] $slaveof                                   = $redis::slaveof,
  Optional[String[1]] $replicaof                                 = $redis::replicaof,
  Integer[-1] $slowlog_log_slower_than                           = $redis::slowlog_log_slower_than,
  Integer[0] $slowlog_max_len                                    = $redis::slowlog_max_len,
  Boolean $stop_writes_on_bgsave_error                           = $redis::stop_writes_on_bgsave_error,
  Boolean $syslog_enabled                                        = $redis::syslog_enabled,
  Optional[String[1]] $syslog_facility                           = $redis::syslog_facility,
  Integer[0] $tcp_backlog                                        = $redis::tcp_backlog,
  Integer[0] $tcp_keepalive                                      = $redis::tcp_keepalive,
  Integer[0] $timeout                                            = $redis::timeout,
  Optional[Stdlib::Port] $tls_port                               = $redis::tls_port,
  Optional[Stdlib::Absolutepath] $tls_cert_file                  = $redis::tls_cert_file,
  Optional[Stdlib::Absolutepath] $tls_key_file                   = $redis::tls_key_file,
  Optional[Stdlib::Absolutepath] $tls_ca_cert_file               = $redis::tls_ca_cert_file,
  Optional[Stdlib::Absolutepath] $tls_ca_cert_dir                = $redis::tls_ca_cert_dir,
  Optional[String[1]] $tls_ciphers                               = $redis::tls_ciphers,
  Optional[String[1]] $tls_ciphersuites                          = $redis::tls_ciphersuites,
  Optional[String[1]] $tls_protocols                             = $redis::tls_protocols,
  Enum['yes', 'no', 'optional'] $tls_auth_clients                = $redis::tls_auth_clients,
  Boolean $tls_replication                                       = $redis::tls_replication,
  Boolean $tls_cluster                                           = $redis::tls_cluster,
  Optional[Boolean] $tls_prefer_server_ciphers                   = $redis::tls_prefer_server_ciphers,
  Variant[Stdlib::Filemode, Enum['']] $unixsocketperm            = $redis::unixsocketperm,
  Integer[0] $ulimit                                             = $redis::ulimit,
  Boolean $ulimit_managed                                        = $redis::ulimit_managed,
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
  Optional[Integer[0]] $service_timeout_start                    = $redis::service_timeout_start,
  Optional[Integer[0]] $service_timeout_stop                     = $redis::service_timeout_stop,
  Boolean $manage_service_file                                   = true,
  String $log_file                                               = "redis-server-${name}.log",
  Stdlib::Absolutepath $pid_file                                 = "/var/run/${service_name}/redis.pid",
  Variant[Stdlib::Absolutepath, Enum['']] $unixsocket            = "/var/run/${service_name}/redis.sock",
  Stdlib::Absolutepath $workdir                                  = "${redis::workdir}/redis-server-${name}",
  Optional[Integer[1]] $io_threads                               = $redis::io_threads,
  Optional[Boolean] $io_threads_do_reads                         = $redis::io_threads_do_reads,
  Optional[Boolean] $cluster_allow_reads_when_down               = $redis::cluster_allow_reads_when_down,
  Optional[Boolean] $cluster_replica_no_failover                 = $redis::cluster_replica_no_failover,
  Optional[Boolean] $dynamic_hz                                  = $redis::dynamic_hz,
  Optional[Boolean] $activedefrag                                = $redis::activedefrag,
  String[1] $active_defrag_ignore_bytes                          = $redis::active_defrag_ignore_bytes,
  Integer[1, 100] $active_defrag_threshold_lower                 = $redis::active_defrag_threshold_lower,
  Integer[1, 100] $active_defrag_threshold_upper                 = $redis::active_defrag_threshold_upper,
  Integer[1, 100] $active_defrag_cycle_min                       = $redis::active_defrag_cycle_min,
  Integer[1, 100] $active_defrag_cycle_max                       = $redis::active_defrag_cycle_max,
  Integer[1] $active_defrag_max_scan_fields                      = $redis::active_defrag_max_scan_fields,
  Optional[Boolean] $jemalloc_bg_thread                          = $redis::jemalloc_bg_thread,
  Optional[Boolean] $rdb_save_incremental_fsync                  = $redis::rdb_save_incremental_fsync,
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

  if $workdir != $redis::workdir {
    file { $workdir:
      ensure => directory,
      group  => $service_group,
      mode   => $workdir_mode,
      owner  => $service_user,
    }
  }

  if $manage_service_file {
    if $title != 'default' {
      $real_service_ensure = $service_ensure == 'running'
      $real_service_enable = $service_enable

      if $notify_service {
        Exec["copy ${redis_file_name_orig} to ${redis_file_name}"] ~> Service["${service_name}.service"]
      } else {
        Exec["copy ${redis_file_name_orig} to ${redis_file_name}"] -> Service["${service_name}.service"]
      }
    } else {
      $real_service_ensure = undef
      $real_service_enable = undef
    }

    systemd::unit_file { "${service_name}.service":
      ensure  => 'present',
      active  => $real_service_ensure,
      enable  => $real_service_enable,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp(
        'redis/service_templates/redis.service.epp',
        {
          bin_path              => $redis::bin_path,
          instance_title        => $name,
          port                  => $port,
          redis_file_name       => $redis_file_name,
          service_name          => $service_name,
          service_user          => $service_user,
          service_timeout_start => $service_timeout_start,
          service_timeout_stop  => $service_timeout_stop,
          ulimit                => $ulimit,
          ulimit_managed        => $ulimit_managed,
        }
      ),
    }
  } else {
    if $ulimit_managed {
      systemd::service_limits { "${service_name}.service":
        limits          => {
          'LimitNOFILE' => $ulimit,
        },
        restart_service => false,
      }
    }
  }

  $_real_log_file = $log_file ? {
    Stdlib::Absolutepath => $log_file,
    default              => "${log_dir}/${log_file}",
  }

  $bind_arr = [$bind].flatten

  file { $redis_file_name_orig:
    ensure  => file,
    owner   => $config_owner,
    group   => $config_group,
    mode    => $config_file_mode,
    content => stdlib::deferrable_epp(
      $conf_template,
      {
        daemonize                     => $daemonize,
        pid_file                      => $pid_file,
        protected_mode                => $protected_mode,
        port                          => $port,
        tcp_backlog                   => $tcp_backlog,
        bind_arr                      => $bind_arr,
        unixsocket                    => $unixsocket,
        unixsocketperm                => $unixsocketperm,
        timeout                       => $timeout,
        tcp_keepalive                 => $tcp_keepalive,
        log_level                     => $log_level,
        log_file                      => $_real_log_file,
        syslog_enabled                => $syslog_enabled,
        syslog_facility               => $syslog_facility,
        databases                     => $databases,
        save_db_to_disk               => $save_db_to_disk,
        save_db_to_disk_interval      => $save_db_to_disk_interval,
        stop_writes_on_bgsave_error   => $stop_writes_on_bgsave_error,
        rdbcompression                => $rdbcompression,
        dbfilename                    => $dbfilename,
        workdir                       => $workdir,
        slaveof                       => $slaveof,
        replicaof                     => $replicaof,
        masterauth                    => $masterauth,
        slave_serve_stale_data        => $slave_serve_stale_data,
        slave_read_only               => $slave_read_only,
        repl_announce_ip              => $repl_announce_ip,
        repl_announce_port            => $repl_announce_port,
        repl_ping_slave_period        => $repl_ping_slave_period,
        repl_timeout                  => $repl_timeout,
        repl_disable_tcp_nodelay      => $repl_disable_tcp_nodelay,
        repl_backlog_size             => $repl_backlog_size,
        repl_backlog_ttl              => $repl_backlog_ttl,
        slave_priority                => $slave_priority,
        min_slaves_to_write           => $min_slaves_to_write,
        min_slaves_max_lag            => $min_slaves_max_lag,
        requirepass                   => $requirepass,
        rename_commands               => $rename_commands,
        maxclients                    => $maxclients,
        maxmemory                     => $maxmemory,
        maxmemory_policy              => $maxmemory_policy,
        maxmemory_samples             => $maxmemory_samples,
        appendonly                    => $appendonly,
        appendfilename                => $appendfilename,
        appendfsync                   => $appendfsync,
        no_appendfsync_on_rewrite     => $no_appendfsync_on_rewrite,
        auto_aof_rewrite_percentage   => $auto_aof_rewrite_percentage,
        auto_aof_rewrite_min_size     => $auto_aof_rewrite_min_size,
        aof_load_truncated            => $aof_load_truncated,
        slowlog_log_slower_than       => $slowlog_log_slower_than,
        slowlog_max_len               => $slowlog_max_len,
        latency_monitor_threshold     => $latency_monitor_threshold,
        notify_keyspace_events        => $notify_keyspace_events,
        hash_max_ziplist_entries      => $hash_max_ziplist_entries,
        hash_max_ziplist_value        => $hash_max_ziplist_value,
        list_max_ziplist_entries      => $list_max_ziplist_entries,
        list_max_ziplist_value        => $list_max_ziplist_value,
        set_max_intset_entries        => $set_max_intset_entries,
        zset_max_ziplist_entries      => $zset_max_ziplist_entries,
        zset_max_ziplist_value        => $zset_max_ziplist_value,
        hll_sparse_max_bytes          => $hll_sparse_max_bytes,
        activerehashing               => $activerehashing,
        output_buffer_limit_slave     => $output_buffer_limit_slave,
        output_buffer_limit_pubsub    => $output_buffer_limit_pubsub,
        hz                            => $hz,
        aof_rewrite_incremental_fsync => $aof_rewrite_incremental_fsync,
        cluster_enabled               => $cluster_enabled,
        cluster_config_file           => $cluster_config_file,
        cluster_node_timeout          => $cluster_node_timeout,
        cluster_slave_validity_factor => $cluster_slave_validity_factor,
        cluster_require_full_coverage => $cluster_require_full_coverage,
        cluster_migration_barrier     => $cluster_migration_barrier,
        extra_config_file             => $extra_config_file,
        tls_port                      => $tls_port,
        tls_cert_file                 => $tls_cert_file,
        tls_key_file                  => $tls_key_file,
        tls_ca_cert_file              => $tls_ca_cert_file,
        tls_ca_cert_dir               => $tls_ca_cert_dir,
        tls_ciphers                   => $tls_ciphers,
        tls_ciphersuites              => $tls_ciphersuites,
        tls_protocols                 => $tls_protocols,
        tls_auth_clients              => $tls_auth_clients,
        tls_replication               => $tls_replication,
        tls_cluster                   => $tls_cluster,
        tls_prefer_server_ciphers     => $tls_prefer_server_ciphers,
        modules                       => $modules,
        io_threads                    => $io_threads,
        io_threads_do_reads           => $io_threads_do_reads,
        cluster_allow_reads_when_down => $cluster_allow_reads_when_down,
        cluster_replica_no_failover   => $cluster_replica_no_failover,
        dynamic_hz                    => $dynamic_hz,
        activedefrag                  => $activedefrag,
        active_defrag_ignore_bytes    => $active_defrag_ignore_bytes,
        active_defrag_threshold_lower => $active_defrag_threshold_lower,
        active_defrag_threshold_upper => $active_defrag_threshold_upper,
        active_defrag_cycle_min       => $active_defrag_cycle_min,
        active_defrag_cycle_max       => $active_defrag_cycle_max,
        active_defrag_max_scan_fields => $active_defrag_max_scan_fields,
        jemalloc_bg_thread            => $jemalloc_bg_thread,
        rdb_save_incremental_fsync    => $rdb_save_incremental_fsync,
      }
    ),
  }

  exec { "copy ${redis_file_name_orig} to ${redis_file_name}":
    path        => '/usr/bin:/bin',
    command     => "cp -p ${redis_file_name_orig} ${redis_file_name}",
    subscribe   => File[$redis_file_name_orig],
    refreshonly => true,
  }
}
