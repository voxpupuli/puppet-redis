# @summary Provides anything required by the install class, such as package
#   repositories.
# @api private
class redis::preinstall {
  if $redis::manage_repo {
    if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '7') <= 0 {
      if $redis::scl {
        if $facts['os']['name'] == 'CentOS' {
          ensure_packages(['centos-release-scl-rh'])
          Package['centos-release-scl-rh'] -> Package[$redis::package_name]
        }
      } else {
        require 'epel'
      }
    } elsif $facts['os']['name'] == 'Ubuntu' and $redis::ppa_repo {
      contain 'apt'
      apt::ppa { $redis::ppa_repo:
      }
    }
  }
}
