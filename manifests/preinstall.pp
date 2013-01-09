# = Class: redis::preinstall
#
# This class provides anything required by the install class.
# Such as package repositories.
#
class redis::preinstall {
  if $::redis::manage_repo {
    case $::operatingsystem {
      'RedHat', 'CentOS', 'Scientific', 'OEL', 'Amazon': {
        $epel_mirror = $::operatingsystemrelease ? {
          /^5/    => 'https://mirrors.fedoraproject.org/metalink?repo=epel-5&arch=$basearch',
          /^6/    => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
          default => Fail['Operating system or release version not supported.'],
        }

        $epel_gpgkey = $::operatingsystemrelease ? {
          /^5/    => 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-5',
          /^6/    => 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6',
          default => Fail['Operating system or release version not supported.'],
        }

        yumrepo { 'epel':
          descr      => 'Extra Packages for Enterprise Linux',
          mirrorlist => $epel_mirror,
          gpgkey     => $epel_gpgkey,
          enabled    => 1,
          gpgcheck   => 1;
        }
      }

      default: {
      }
    }
  }
}

