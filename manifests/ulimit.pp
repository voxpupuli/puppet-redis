# Redis class for configuring ulimit
# Used to DRY up the config class, and
# move the logic for ulimit changes all
# into one place.
#
# Parameters are not required as it's a
# private class only referencable from
# the redis module, where the variables
# would already be defined
#
# @example
#   contain redis::ulimit
#
# @author - Peter Souter
#
# @api private
class redis::ulimit {
  assert_private('The redis::ulimit class is only to be called from the redis::config class')

  $service_provider_lookup = pick(getvar('service_provider'), false)

  if $redis::managed_by_cluster_manager {
    file { '/etc/security/limits.d/redis.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "redis soft nofile ${redis::ulimit}\nredis hard nofile ${redis::ulimit}\n",
    }
  }
  if $service_provider_lookup == 'systemd' {
    file { "/etc/systemd/system/${redis::service_name}.service.d/":
      ensure                  => 'directory',
      owner                   => 'root',
      group                   => 'root',
      selinux_ignore_defaults => true,
    }

    file { "/etc/systemd/system/${redis::service_name}.service.d/limit.conf":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0444',
    }
    augeas { 'Systemd redis ulimit' :
      incl    => "/etc/systemd/system/${redis::service_name}.service.d/limit.conf",
      lens    => 'Systemd.lns',
      changes => [
        "defnode nofile Service/LimitNOFILE \"\"",
        "set \$nofile/value \"${redis::ulimit}\"",
      ],
    }
    # Only necessary for Puppet < 6.1.0,
    # See https://github.com/puppetlabs/puppet/commit/f8d5c60ddb130c6429ff12736bfdb4ae669a9fd4
    if versioncmp($facts['puppetversion'],'6.1.0') < 0 {
      include systemd::systemctl::daemon_reload
      Augeas['Systemd redis ulimit'] ~> Class['systemd::systemctl::daemon_reload']
    }
  } else {
    case $facts['os']['family'] {
      'Debian': {
        augeas { 'redis ulimit':
          context => '/files/etc/default/redis-server',
          changes => "set ULIMIT ${redis::ulimit}",
        }
      }
      'RedHat': {
        augeas { 'redis ulimit':
          context => '/files/etc/sysconfig/redis',
          changes => "set ULIMIT ${redis::ulimit}",
        }
      }
      default: {
        warning("Not sure how to set ULIMIT on non-systemd OSFamily ${facts['os']['family']}, PR's welcome")
      }
    }
  }
}
