require 'redis'

module Puppet::Parser::Functions
  newfunction(:redisget, :type => :rvalue, :doc => <<-EOS
    Returns the value of the key being looked up or nil if the key does not
    exist. Takes two arguments with an optional third. The first being a string
    value of the key to be looked up, the second is the URL to the Redis service
    and the third optional argument is a default value to be used if the lookup
    fails.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "redisget(): Wrong number of arguments given (#{args.size} for 2 or 3)") if args.size != 2 and args.size != 3

    key = args[0]
    url = args[1]

    if args.size == 3
      default = args[2]
      raise(Puppet::ParseError, "redisget(): Wrong argument type given (#{default.class} for String) for arg3 (default)") if default.is_a?(String) == false
    end

    raise(Puppet::ParseError, "redisget(): Wrong argument type given (#{key.class} for String) for arg1 (key)") if key.is_a?(String) == false
    raise(Puppet::ParseError, "redisget(): Wrong argument type given (#{url.class} for String) for arg2 (url)") if url.is_a?(String) == false

    begin
      redis = Redis.new(:url => url)
      returned_value = redis.get(key)
      if returned_value == nil and defined?(default) != nil
        default
      else
        returned_value
      end
    rescue Exception => e
      if default
        default
      else
        raise(Puppet::Error, "connection to redis server failed - #{e}")
      end
    end
  end
end
