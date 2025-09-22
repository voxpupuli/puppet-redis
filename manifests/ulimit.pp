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

  if $redis::managed_by_cluster_manager {
    file { "/etc/security/limits.d/${redis::service_user}.conf":
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "${redis::service_user} soft nofile ${redis::ulimit}\n${redis::service_user} hard nofile ${redis::ulimit}\n",
    }
  }

  # Migrate from the old managed service
  file { "/etc/systemd/system/${redis::service_name}.service.d/limit.conf":
    ensure => absent,
  }
}
