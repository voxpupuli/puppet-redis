# @summary Allows various administrative settings for Redis
# As documented in the FAQ and https://redis.io/topics/admin.
# For disabling Transparent Huge Pages (THP), use separate module such as:
# https://forge.puppet.com/modules/alexharvey/disable_transparent_hugepage
#
# Note that this class requires the herculesteam/augeasproviders_sysctl module.
#
# @example
#   include redis::administration
#
# @example
#   class {'redis::administration':
#     enable_overcommit_memory => false,
#   }
#
# @param enable_overcommit_memory
#   Enable the overcommit memory setting
# @param somaxconn
#   Set somaxconn value
# @param somaxconn_sysctl
#   Name of the sysctl that sets the somaxconn value
#   (`kern.ipc.soacceptqueue` on FreeBSD).
#
# @author - Peter Souter
# @see https://redis.io/topics/admin
# @see https://forge.puppet.com/herculesteam/augeasproviders_sysctl
#
class redis::administration (
  Boolean $enable_overcommit_memory = true,
  Integer[0] $somaxconn             = 65535,
  String[1] $somaxconn_sysctl       = 'net.core.somaxconn',
) {
  if $enable_overcommit_memory {
    sysctl { 'vm.overcommit_memory':
      ensure => 'present',
      value  => '1',
    }
  }

  if $somaxconn > 0 {
    sysctl { $somaxconn_sysctl:
      ensure => 'present',
      value  => $somaxconn,
    }
  }
}
