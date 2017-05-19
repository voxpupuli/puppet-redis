require 'redis'

module Puppet::Parser::Functions
  newfunction(:redisget, :type => :rvalue, :doc => <<-DOC
Returns the value of the key being looked up or nil if the key does not
exist. Takes two arguments, the first being a string value of the key to be
looked up and the second is the URL to the Redis service.
@param redis_key [String] The key to look up in redis.
@param redis_uri [String] The endpoint of the Redis instance.
@return [String] The value of the key from redis
@return [String] An empty string eg. `''`
@example Calling the function.
  $version = redisget('version.myapp', 'redis://redis.example.com:6379')
DOC
  ) do |args|

    raise(Puppet::ParseError, "redisget(): Wrong number of arguments given (#{args.size} for 2)") if args.size != 2

    key = args[0]
    url = args[1]

    raise(Puppet::ParseError, "redisget(): Wrong argument type given (#{key.class} for String") if key.is_a?(String) == false
    raise(Puppet::ParseError, "redisget(): Wrong argument type given (#{url.class} for String") if url.is_a?(String) == false

    redis = Redis.new(:url => url)
    redis.get(key)
  end
end
