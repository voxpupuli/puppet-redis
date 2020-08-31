# @summary Set a global config for Redis
#
# @param scl
#   Use a specific Software CoLlection on Red Hat based systems
class redis::globals (
  Optional[String] $scl = undef,
) {
  if $scl and $facts['os']['family'] != 'RedHat' {
    fail('SCLs are only supported on the Red Hat OS family')
  }
}
