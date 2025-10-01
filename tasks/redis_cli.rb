#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def redis_cli(command)
  cli = 'redis-cli'
  begin
    Open3.capture3("type #{cli}")[2].exited?
  rescue Errno::ENOENT
    cli = 'valkey-cli'
  end

  stdout, stderr, status = Open3.capture3(cli, command)
  raise Puppet::Error, stderr if status != 0

  { status: stdout.strip }
end

params = JSON.parse($stdin.read)
command = params['command']

begin
  result = redis_cli(command)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end
