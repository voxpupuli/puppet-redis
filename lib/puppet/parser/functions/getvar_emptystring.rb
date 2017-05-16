module Puppet::Parser::Functions

  newfunction(:getvar_emptystring, :type => :rvalue, :doc => <<-DOC
Return a variable in a remote namespace, but returns an empty
string if the variable is undefined or can't be found.
This is useful when trying to lookup a value that might be undefined
on first run, like a fact for an application that will be installed as
part of a Puppet run, but you don't want the reference to an undefined variable
to cause an error when strict variables are enabled.
@param variable [String] The variable to lookup
@return [String] The value of the variable if found
@return [String] An empty string if the variable is not found eg. `''`
@example Checking a variable exists (Equivalent to $foo = $site::data::foo)
  $foo = getvar('site::data::foo')
@example Calling the function. (Equivalent to $bar = $site::data::bar)
  $datalocation = 'site::data'
  $bar = getvar("${datalocation}::bar")
@example Combining with the pick() function
  $redis_version_real = pick(getvar_emptystring('redis_server_version'), '3.2.1')
DOC
  ) do |args|

    unless args.length == 1
      raise Puppet::ParseError, ("getvar_emptystring(): wrong number of arguments (#{args.length}; must be 1)")
    end

    begin
      result = self.lookupvar("#{args[0]}")

      result = '' if result.nil?

      result
    rescue Puppet::ParseError # Eat the exception if strict_variables = true is set and return an empty string
      return ''
    end

  end

end
