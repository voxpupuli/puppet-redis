# @summary This class installs the application.
# @api private
class redis::install {
  if $redis::manage_package {
    package { $redis::package_name:
      ensure => $redis::package_ensure,
    }
  }
}
