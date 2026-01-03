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
    group  => pick($redis::log_dir_group, $redis::service_group),
    mode   => $redis::log_dir_mode,
    owner  => $redis::service_user,
  }

  file { $redis::workdir:
    ensure => directory,
    group  => pick($redis::workdir_group, $redis::service_group),
    mode   => $redis::workdir_mode,
    owner  => pick($redis::workdir_owner, $redis::service_user),
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
      acls                => $redis::acls,
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
        group  => pick($redis::debdefault_group, $redis::config_group),
        mode   => pick($redis::debdefault_file_mode, $redis::config_file_mode),
        owner  => pick($redis::debdefault_owner, $redis::config_owner),
      }
    }

    default: {
    }
  }
}
