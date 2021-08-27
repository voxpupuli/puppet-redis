require 'redis'
# @summary Returns the value of the key being looked up or `undef` if the key does not exist.
# Takes two arguments with an optional third. The first being a string
# value of the key to be looked up, the second is the URL to the Redis service
# and the third optional argument is a default value to be used if the lookup
# fails.
#
# example usage
# ```
# $version = redis::get('version.myapp', 'redis://redis.example.com:6379')
# $version_with_default = redis::get('version.myapp', 'redis://redis.example.com:6379', $::myapp_version)
# ```
Puppet::Functions.create_function(:'redis::get') do
  # @param key The key to look up in redis
  # @param url The endpoint of the Redis instance
  # @param default The value to return if the key is not found or the connection to Redis fails
  # @return Returns the value of the key from Redis
  dispatch :get do
    param 'String[1]', :key
    param 'Redis::RedisUrl', :url
    optional_param 'String', :default
    return_type 'Optional[String]'
  end

  def get(key, url, default = nil)
    Redis.new(url: url).get(key) || default
  rescue Redis::CannotConnectError, SocketError => e
    raise Puppet::Error, "connection to redis server failed - #{e}" unless default
    Puppet.debug "Connection to redis failed with #{e} - Returning default value of #{default}"
    default
  end
end
