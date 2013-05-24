# == Class: redis::service
#
# This class manages the Redis daemon.
#
class redis::service {
  service { $::redis::daemon_name:
    ensure    => $::redis::daemon_ensure,
    enable    => $::redis::daemon_enable,
    hasstatus => $::redis::daemon_hasstatus;
  }
}

