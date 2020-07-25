# @summary Provides anything required by the install class, such as package
#   repositories.
# @api private
class redis::preinstall {
  if $redis::manage_repo {
    if $facts['os']['family'] == 'RedHat' {
      if $facts['os']['name'] != 'Fedora' {
        if $redis::scl {
          if $facts['os']['name'] == 'CentOS' {
            ensure_packages(['centos-release-scl-rh'])
            Package['centos-release-scl-rh'] -> Package[$redis::package_name]
          }
        } else {
          require 'epel'
        }
      }
    } elsif $facts['os']['name'] == 'Debian' {
      contain 'apt'
      apt::source { 'dotdeb':
        location => 'http://packages.dotdeb.org/',
        repos    => 'all',
        key      => {
          id     => '6572BBEF1B5FF28B28B706837E3F070089DF5277',
          source => 'http://www.dotdeb.org/dotdeb.gpg',
        },
        include  => { 'src' => true },
      }
    } elsif $facts['os']['name'] == 'Ubuntu' {
      contain 'apt'
      apt::ppa { $redis::ppa_repo:
      }
    }
  }
}
