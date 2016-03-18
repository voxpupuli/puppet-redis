# = Class: redis::install
#
# This class installs the application.
#
class redis::install {
  unless defined(Package['$::redis::package_name']) {
    ensure_resource('package', $::redis::package_name, {
      'ensure' => $::redis::package_ensure
    })

    # We want to install redis but we don't want redis running right now.
    # We have a service class to ensure that.
    service { $::redis::service_name:
      ensure     => 'stopped',
      enable     => $::redis::service_enable,
      hasrestart => $::redis::service_hasrestart,
      hasstatus  => $::redis::service_hasstatus,
      provider   => $::redis::service_provider,
    }
  }
}

