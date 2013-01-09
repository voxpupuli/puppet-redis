# = Class: redis::config
#
# This class provides configuration for Redis.
#
class redis::config {
  $slaveof    = $::redis::slaveof
  $masterauth = $::redis::masterauth

  File {
    owner  => $::redis::config_user,
    group  => $::redis::config_group,
    notify => Service[$::redis::daemon_name],
  }

  file {
    $::redis::config_dir:
      ensure => directory;

    $::redis::config_file:
      ensure  => present,
      content => template('redis/redis.conf.erb');

    $::redis::log_dir:
      ensure => directory,
      owner  => $::redis::daemon_user,
      group  => $::redis::daemon_group;
  }
}

