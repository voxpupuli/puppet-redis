type Redis::MasterName = Hash[String, Struct[{
  redis_host                       => Stdlib::Host,
  redis_port                       => Stdlib::Port,
  quorum                           => Integer[1],
  down_after                       => Integer[1],
  parallel_sync                    => Integer[0],
  failover_timeout                 => Integer[1],
  Optional[auth_pass]              => String,
  Optional[notification_script]    => Stdlib::Absolutepath,
  Optional[client_reconfig_script] => Stdlib::Absolutepath,}
],1]
