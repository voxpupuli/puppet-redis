# @summary This class installs the application.
# @api private
class redis::install {
  if $redis::manage_package {
    package { $redis::package_name:
      ensure => $redis::package_ensure,
    }
  }

  if $redis::dnf_module_stream {
    if $facts['os']['family'] != 'RedHat' {
      fail('DNF modules are only supported on the Red Hat OS family')
    }

    class { 'redis::dnfmodule':
      ensure => $redis::dnf_module_stream,
      before => Package[$redis::package_name],
    }
  }
}
