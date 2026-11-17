# @summary This class manages the Redis daemon.
# @api private
class redis::service {
  if $redis::service_manage {
    if $redis::service_provider == 'freebsd' {
      # Boot-time activation is managed through <provider>_enable, which the
      # rc script reads for the default instance and for all profiles.
      $_enable_value = $redis::service_enable ? {
        true    => 'YES',
        default => 'NO',
      }

      file { "/etc/rc.conf.d/${redis::provider}/enable":
        ensure  => file,
        owner   => 'root',
        group   => 'wheel',
        mode    => '0644',
        content => "${redis::provider}_enable=\"${_enable_value}\"\n",
      }

      # The default instance is controlled through the rc script without a
      # profile argument. Instance profiles are controlled by redis::instance.
      if $redis::default_install {
        service { $redis::service_name:
          ensure  => $redis::service_ensure,
          require => File["/etc/rc.conf.d/${redis::provider}/enable"],
        }
      }
    } else {
      service { $redis::service_name:
        ensure => $redis::service_ensure,
        enable => $redis::service_enable,
      }
    }
  }
}
