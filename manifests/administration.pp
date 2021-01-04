# Allows various adminstrative settings for Redis
# As documented in the FAQ and https://redis.io/topics/admin
#
# @example
#   include redis::administration
#
# @example
#   class {'redis::administration':
#     disable_thp => false,
#   }
#
# @param enable_overcommit_memory
#   Enable the overcommit memory setting
# @param disable_thp
#   Disable Transparent Huge Pages
# @param somaxconn
#   Set somaxconn value
#
# @author - Peter Souter
# @see https://redis.io/topics/admin
#
class redis::administration (
  Boolean $enable_overcommit_memory = true,
  Boolean $disable_thp              = true,
  Integer[0] $somaxconn             = 65535,
  String[1] $hugeadm_package        = $redis::params::hugeadm_package,
) inherits redis::params {
  if $enable_overcommit_memory {
    sysctl { 'vm.overcommit_memory':
      ensure => 'present',
      value  => '1',
    }
  }

  if $disable_thp {
    package { $hugeadm_package:
      ensure => 'present',
    }

    exec { 'systemd run_once disable_thp':
      command     => '/usr/bin/systemctl start disable_thp.service',
      refreshonly => true,
      subscribe   => Systemd::Unit_file['disable_thp.service'],
    }
  }

  $ensure_thp_service = $disable_thp ? { true => 'present', false => 'absent' }

  systemd::unit_file { 'disable_thp.service':
    ensure  => $ensure_thp_service,
    active  => false,
    enable  => $disable_thp,
    content => file("${module_name}/service_files/disable_thp.service"),
  }

  if $somaxconn > 0 {
    sysctl { 'net.core.somaxconn':
      ensure => 'present',
      value  => $somaxconn,
    }
  }
}
