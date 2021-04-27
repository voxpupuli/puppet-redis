# @summary This class manages the Redis daemon.
# @api private
class redis::service {
  if $redis::service_manage {
    service { $redis::service_name:
      ensure => $redis::service_ensure,
      enable => $redis::service_enable,
    }
  }
}
