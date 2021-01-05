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
  }

  $ensure_thp = $disable_thp ? { true => 'present', false => 'absent' }

  systemd::timer { 'disable_thp.timer':
    ensure          => $ensure_thp,
    timer_content   => file("${module_name}/service_files/disable_thp.timer"),
    service_content => file("${module_name}/service_files/disable_thp.service"),
    active          => false,
    enable          => $disable_thp,
  }

  if $somaxconn > 0 {
    sysctl { 'net.core.somaxconn':
      ensure => 'present',
      value  => $somaxconn,
    }
  }
}
