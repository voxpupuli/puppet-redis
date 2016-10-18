#
#
define redis::instance (
  $activerehashing                   = $::redis::activerehashing,
  $aof_load_truncated                = $::redis::aof_load_truncated,
  $aof_rewrite_incremental_fsync     = $::redis::aof_rewrite_incremental_fsync,
  $appendfilename                    = $::redis::appendfilename,
  $appendfsync                       = $::redis::appendfsync,
  $appendonly                        = $::redis::appendonly,
  $auto_aof_rewrite_min_size         = $::redis::auto_aof_rewrite_min_size,
  $auto_aof_rewrite_percentage       = $::redis::auto_aof_rewrite_percentage,
  $bind                              = $::redis::bind,
  $cluster_config_file               = $::redis::cluster_config_file,
  $cluster_enabled                   = $::redis::cluster_enabled,
  $cluster_node_timeout              = $::redis::cluster_node_timeout,
  $daemonize                         = $::redis::daemonize,
  $databases                         = $::redis::databases,
  $dbfilename                        = $::redis::dbfilename,
  $extra_config_file                 = $::redis::extra_config_file,
  $hash_max_ziplist_entries          = $::redis::hash_max_ziplist_entries,
  $hash_max_ziplist_value            = $::redis::hash_max_ziplist_value,
  $hll_sparse_max_bytes              = $::redis::hll_sparse_max_bytes,
  $hz                                = $::redis::hz,
  $latency_monitor_threshold         = $::redis::latency_monitor_threshold,
  $list_max_ziplist_entries          = $::redis::list_max_ziplist_entries,
  $list_max_ziplist_value            = $::redis::list_max_ziplist_value,
  $log_level                         = $::redis::log_level,
  $masterauth                        = $::redis::masterauth,
  $maxclients                        = $::redis::maxclients,
  $maxmemory                         = $::redis::maxmemory,
  $maxmemory_policy                  = $::redis::maxmemory_policy,
  $maxmemory_samples                 = $::redis::maxmemory_samples,
  $min_slaves_max_lag                = $::redis::min_slaves_max_lag,
  $min_slaves_to_write               = $::redis::min_slaves_to_write,
  $no_appendfsync_on_rewrite         = $::redis::no_appendfsync_on_rewrite,
  $notify_keyspace_events            = $::redis::notify_keyspace_events,
  $port                              = $::redis::port,
  $rdbcompression                    = $::redis::rdbcompression,
  $repl_backlog_size                 = $::redis::repl_backlog_size,
  $repl_backlog_ttl                  = $::redis::repl_backlog_ttl,
  $repl_disable_tcp_nodelay          = $::redis::repl_disable_tcp_nodelay,
  $repl_ping_slave_period            = $::redis::repl_ping_slave_period,
  $repl_timeout                      = $::redis::repl_timeout,
  $requirepass                       = $::redis::requirepass,
  $save_db_to_disk                   = $::redis::save_db_to_disk,
  $set_max_intset_entries            = $::redis::set_max_intset_entries,
  $slave_priority                    = $::redis::slave_priority,
  $slave_read_only                   = $::redis::slave_read_only,
  $slave_serve_stale_data            = $::redis::slave_serve_stale_data,
  $global_slaveof                    = $::redis::slaveof,
  $slowlog_log_slower_than           = $::redis::slowlog_log_slower_than,
  $slowlog_max_len                   = $::redis::slowlog_max_len,
  $stop_writes_on_bgsave_error       = $::redis::stop_writes_on_bgsave_error,
  $syslog_enabled                    = $::redis::syslog_enabled,
  $syslog_facility                   = $::redis::syslog_facility,
  $tcp_backlog                       = $::redis::tcp_backlog,
  $tcp_keepalive                     = $::redis::tcp_keepalive,
  $timeout                           = $::redis::timeout,
  $unixsocket                        = $::redis::unixsocket,
  $unixsocketperm                    = $::redis::unixsocketperm,
  $workdir                           = $::redis::workdir,
  $zset_max_ziplist_entries          = $::redis::zset_max_ziplist_entries,
  $zset_max_ziplist_value            = $::redis::zset_max_ziplist_value,
  $client_output_buffer_limit_normal = $::redis::client_output_buffer_limit_normal,
  $client_output_buffer_limit_slave  = $::redis::client_output_buffer_limit_slave,
  $client_output_buffer_limit_pubsub = $::redis::client_output_buffer_limit_pubsub,
 )  {

  $instance_name          = "redis-${title}"
  $service_name           = $instance_name
  $config_dir             = "${::redis::config_dir}/${service_name}"
  $config_file            = "${config_dir}/redis.conf"
  $config_file_orig       = "${config_dir}/redis.conf.puppet"
  $instance_init_file     = "/etc/init.d/${service_name}"
  $pid_file               = "/var/run/redis/${instance_name}.pid"
  $log_file               = "/var/log/redis/${instance_name}.log"
  $redis_binary_path      = $::redis::redis_binary_path
  $redis_binary_name      = $instance_name
  $instance_symlink       = "${::redis::redis_binary_path}/${instance_name}"
  $redis_server_binary    = "${::redis::redis_binary_path}/${::redis::redis_binary_name}"

  # We should not be making a host a slave of itself
  if ($global_slaveof != $::fqdn) {
      $slaveof = $global_slaveof
      $slaveof_port = $port
  }
  if $::redis::notify_service {
    service { $service_name:
      ensure     => $::redis::service_ensure,
      enable     => $::redis::service_enable,
      hasrestart => $::redis::service_hasrestart,
      hasstatus  => $::redis::service_hasstatus,
      provider   => $::redis::service_provider,
    }

    File {
      owner  => $::redis::config_owner,
      group  => $::redis::config_group,
      mode   => $::redis::config_file_mode,
      notify => Service[$service_name],
    }
  } else {
    File {
      owner => $::redis::config_owner,
      group => $::redis::config_group,
      mode  => $::redis::config_file_mode,
    }
  }

  file {
    $config_dir:
      ensure => directory,
      mode   => $::redis::config_dir_mode;

    $config_file_orig:
      ensure  => present,
      content => template($::redis::conf_template);

    $instance_init_file:
      ensure  => present,
      content => template($::redis::redis_init_template),
      mode    => $::redis::redis_init_file_mode;

    $instance_symlink:
      ensure => 'link',
      target => $redis_server_binary;
  }

  exec {
    "cp -p ${config_file_orig} ${config_file}":
      path        => '/usr/bin:/bin',
      subscribe   => File[$config_file_orig],
      refreshonly => true;
  } ~> Service <| title == $::redis::service_name |>

  # Adjust /etc/default/redis-server on Debian systems
  case $::osfamily {
    'Debian': {
      file { '/etc/default/redis-server':
        ensure => present,
        group  => $::redis::config_group,
        mode   => $::redis::config_file_mode,
        owner  => $::redis::config_owner,
      }

      if $::redis::ulimit {
        augeas { 'redis ulimit' :
          context => '/files/etc/default/redis-server',
          changes => "set ULIMIT ${::redis::ulimit}",
        }
      }
    }

    default: {
    }
  }
}
