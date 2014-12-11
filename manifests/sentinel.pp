
class redis::sentinel (
  $config_dir        = $::redis::params::config_dir,
  $config_dir_mode   = $::redis::params::config_dir_mode,
  $config_file       = $::redis::params::sentinel_config_file,
  $config_file_orig  = $::redis::params::sentinel_config_file_orig,
  $config_file_mode  = $::redis::params::sentinel_config_file_mode,
  $config_file_group = $::redis::params::sentinel_config_file_group,
  $config_file_owner = $::redis::params::sentinel_config_file_owner, 
  $conf_template     = $::redis::params::sentinel_conf_template,
  $down_after        = $::redis::params::sentinel_down_after,
  $failover_timeout  = $::redis::params::sentinel_failover_timeout,
  $log_dir           = $::redis::params::log_dir,
  $master_name       = $::redis::params::sentinel_master_name,
  $redis_host        = $::redis::params::bind,
  $redis_port        = $::redis::params::port,
  $parallel_sync     = $::redis::params::sentinel_parallel_sync,
  $quorum            = $::redis::params::sentinel_quorum,
  $sentinel_port     = $::redis::params::sentinel_port,
  $service_group     = $::redis::params::service_group,
  $service_name      = $::redis::params::sentinel_service_name,
  $service_user      = $::redis::params::service_user,
  $working_dir       = $::redis::params::sentinel_working_dir,
) inherits redis::params {

  file {
#     $config_dir:
#       ensure => directory,
#       mode   => $config_dir_mode;

    $config_file_orig:
      ensure  => present,
      content => template($conf_template);
#     require => File[$config_dir];

    $config_file:
      owner => $service_user,
      group => $service_group,
      mode  => $config_file_mode;

#     $log_dir:
#       ensure => directory,
#       group  => $service_group,
#       mode   => $config_dir_mode,
#       owner  => $service_user;
  }

  exec {
    "cp $config_file_orig $config_file":
      path        => "/usr/bin:/bin",
      subscribe   => File[$config_file_orig],
      notify      => Service[$service_name],
      refreshonly => true;
  }

  service { $service_name:
    ensure     => $::redis::params::service_ensure,
    enable     => $::redis::params::service_enable,
    hasrestart => $::redis::params::service_hasrestart,
    hasstatus  => $::redis::params::service_hasstatus,
  }

}
