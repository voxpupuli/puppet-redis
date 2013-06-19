# == Class: redis::config
#
# This class provides configuration for Redis.
#
class redis::config {
  File {
    owner  => $::redis::config_user,
    group  => $::redis::config_group,
    notify => Service[$::redis::service_name],
  }

  file {
    $::redis::config_dir:
      ensure => directory;

    $::redis::config_file:
      ensure  => present,
      content => template('redis/redis.conf.erb');

    $::redis::log_dir:
      ensure => directory,
      owner  => $::redis::service_user,
      group  => $::redis::service_group;
  }
}

