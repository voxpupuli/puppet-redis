# @summary Manage the DNF module
#
# On EL8+ and Fedora DNF can manage modules. This is a method of providing
# multiple versions on the same OS. Only one DNF module stream can be active at the
# same time.
#
# @param ensure
#   Value of ensure parameter for redis dnf module package
#
# @param module
#   Name of the redis dnf package
#
# @api private
class redis::dnfmodule (
  String[1] $ensure = 'installed',
  String[1] $module = 'redis',
) {
  package { 'redis dnf module':
    ensure      => $ensure,
    name        => $module,
    enable_only => true,
    provider    => 'dnfmodule',
  }
}
