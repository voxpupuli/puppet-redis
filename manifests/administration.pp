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
  file { '/etc/systemd/system/disable_thp.service':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => file('redis/service_files/disable_thp.service'),
  }

  # Only necessary for Puppet < 6.1.0,
  # See https://github.com/puppetlabs/puppet/commit/f8d5c60ddb130c6429ff12736bfdb4ae669a9fd4
  if versioncmp($facts['puppetversion'],'6.1.0') < 0 {
    include systemd::systemctl::daemon_reload
    File['/etc/systemd/system/disable_thp.service'] ~> Class['systemd::systemctl::daemon_reload']
  }

  $hugeadm_package = $facts['os']['family'] ? {
    'RedHat' => 'libhugetlbfs-utils',
    'Debian' => 'libhugetlbfs',
    'Archlinux' => 'libhugetlbfs',
    default  => 'hugepages',
  }

  package { $hugeadm_package:
    ensure => 'present',
  }

  service { 'disable_thp':
    ensure    => false,
    enable    => $disable_thp,
    subscribe => File['/etc/systemd/system/disable_thp.service'],
  }

  exec { 'systemd run_once disable_thp':
    command     => '/usr/bin/systemctl start disable_thp.service',
    refreshonly => true,
    subscribe   => File['/etc/systemd/system/disable_thp.service'],
    require     => Service['disable_thp'],
  }

  if $somaxconn > 0 {
    sysctl { 'net.core.somaxconn':
      ensure => 'present',
      value  => $somaxconn,
    }
  }
}
