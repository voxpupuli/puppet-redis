# = Class: redis
#
# This class installs redis
#
# == Parameters:
#
# $parameter:: This global variable is used to set
#
# == Actions:
#   - Install and configure Redis
#
# == Sample Usage:
#
#   class { 'redis': }
#
#   class { 'redis':
#     manage_repo => true;
#   }
#
class redis (
  $config_dir                  = $::redis::params::config_dir,
  $config_file                 = $::redis::params::config_file,
  $config_group                = $::redis::params::config_group,
  $config_user                 = $::redis::params::config_user,
  $daemon_enable               = $::redis::params::daemon_enable,
  $daemon_ensure               = $::redis::params::daemon_ensure,
  $daemon_group                = $::redis::params::daemon_group,
  $daemon_hasstatus            = $::redis::params::daemon_hasstatus,
  $daemon_name                 = $::redis::params::daemon_name,
  $daemon_user                 = $::redis::params::daemon_user,
  $manage_repo                 = $::redis::params::manage_repo,
  $package_deps                = $::redis::params::package_deps,
  $package_ensure              = $::redis::params::package_ensure,
  $package_name                = $::redis::params::package_name,
  $activerehashing             = $::redis::params::activerehashing,
  $appendfsync                 = $::redis::params::appendfsync,
  $appendonly                  = $::redis::params::appendonly,
  $auto_aof_rewrite_min_size   = $::redis::params::auto_aof_rewrite_min_size,
  $auto_aof_rewrite_percentage = $::redis::params::auto_aof_rewrite_percentage,
  $bind                        = $::redis::params::bind,
  $daemonize                   = $::redis::params::daemonize,
  $databases                   = $::redis::params::databases,
  $dbfilename                  = $::redis::params::dbfilename,
  $hash_max_zipmap_entries     = $::redis::params::hash_max_zipmap_entries,
  $hash_max_zipmap_value       = $::redis::params::hash_max_zipmap_value,
  $list_max_ziplist_entries    = $::redis::params::list_max_ziplist_entries,
  $list_max_ziplist_value      = $::redis::params::list_max_ziplist_value,
  $log_dir                     = $::redis::params::log_dir,
  $log_file                    = $::redis::params::log_file,
  $log_level                   = $::redis::params::log_level,
  $masterauth                  = $::redis::params::masterauth,
  $no_appendfsync_on_rewrite   = $::redis::params::no_appendfsync_on_rewrite,
  $pid_file                    = $::redis::params::pid_file,
  $port                        = $::redis::params::port,
  $rdbcompression              = $::redis::params::rdbcompression,
  $repl_ping_slave_period      = $::redis::params::repl_ping_slave_period,
  $repl_timeout                = $::redis::params::repl_timeout,
  $set_max_intset_entries      = $::redis::params::set_max_intset_entries,
  $slave_serve_stale_data      = $::redis::params::slave_serve_stale_data,
  $slaveof                     = $::redis::params::slaveof,
  $slowlog_log_slower_than     = $::redis::params::slowlog_log_slower_than,
  $slowlog_max_len             = $::redis::params::slowlog_max_len,
  $timeout                     = $::redis::params::timeout,
  $vm_max_memory               = $::redis::params::vm_max_memory,
  $vm_max_threads              = $::redis::params::vm_max_threads,
  $vm_page_size                = $::redis::params::vm_page_size,
  $vm_pages                    = $::redis::params::vm_pages,
  $vm_swap_file                = $::redis::params::vm_swap_file,
  $workdir                     = $::redis::params::workdir,
  $zset_max_ziplist_entries    = $::redis::params::zset_max_ziplist_entries,
  $zset_max_ziplist_value      = $::redis::params::zset_max_ziplist_value,
) inherits redis::params {

  include preinstall
  include install
  include config
  include service

  Class['preinstall'] ->
  Class['install'] ->
  Class['config'] ->
  Class['service']

  # Sanity check
  if $::redis::slaveof {
    if $::redis::bind =~ /^127.0.0./ {
      fail "Replication is not possible when binding to ${::redis::bind}."
    }
  }
}

