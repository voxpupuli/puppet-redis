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
      apt::ppa { $redis::ppa_repo: }
    } elsif $facts['os']['family'] == 'Debian' and $redis::redis_apt_repo {
      include 'apt'

      apt::source { 'redis':
        location => $redis::apt_location,
        release  => $redis::apt_release,
        repos    => $redis::apt_repos,
        key      => {
          id          => $redis::apt_key_id,
          server      => $redis::apt_key_server,
          key_options => $redis::apt_key_options,
        },
      }
    }
  }
}
