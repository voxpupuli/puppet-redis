# @summary This class provides configuration for Redis.
# @api private
class redis::config {
  File {
    owner  => $redis::config_owner,
    group  => $redis::config_group,
    mode   => $redis::config_file_mode,
  }

  file { $redis::config_dir:
    ensure => directory,
    mode   => $redis::config_dir_mode,
  }

  file { $redis::log_dir:
    ensure => directory,
    group  => $redis::service_group,
    mode   => $redis::log_dir_mode,
    owner  => $redis::service_user,
  }

  file { $redis::workdir:
    ensure => directory,
    group  => $redis::service_group,
    mode   => $redis::workdir_mode,
    owner  => $redis::service_user,
  }

  if $redis::default_install {
    redis::instance { 'default':
      pid_file            => $redis::pid_file,
      log_file            => $redis::log_file,
      unixsocket          => $redis::unixsocket,
      workdir             => $redis::workdir,
      daemonize           => $redis::daemonize,
      service_name        => $redis::service_name,
      manage_service_file => $redis::manage_service_file,
    }
  }

  if $redis::ulimit_managed {
    contain redis::ulimit
  }

  # Adjust /etc/default/redis-server on Debian systems
  case $facts['os']['family'] {
    'Debian': {
      file { '/etc/default/redis-server':
        ensure => file,
        group  => $redis::config_group,
        mode   => $redis::config_file_mode,
        owner  => $redis::config_owner,
      }
    }

    default: {
    }
  }
}
