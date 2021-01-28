type Redis::SentinelMonitorDefaults = Struct[{
  redis_host             => Stdlib::Host,
  redis_port             => Stdlib::Port,
  quorum                 => Integer[1],
  down_after             => Integer[1],
  parallel_sync          => Integer[0],
  failover_timeout       => Integer[1],
  monitor_name           => Optional[String],
  auth_pass              => Optional[String],
  notification_script    => Optional[Stdlib::Absolutepath],
  client_reconfig_script => Optional[Stdlib::Absolutepath],
}]
