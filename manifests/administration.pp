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
) {
  if $enable_overcommit_memory {
    sysctl { 'vm.overcommit_memory':
      ensure => 'present',
      value  => '1',
    }
  }

  if $disable_thp {
    exec { 'Disable Hugepages':
      command => 'echo never > /sys/kernel/mm/transparent_hugepage/enabled',
      path    => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
      onlyif  => 'test -f /sys/kernel/mm/transparent_hugepage/enabled',
      unless  => 'cat /sys/kernel/mm/transparent_hugepage/enabled | grep "\[never\]"',
    }
  }

  if $somaxconn > 0 {
    sysctl { 'net.core.somaxconn':
      ensure => 'present',
      value  => $somaxconn,
    }
  }
}
