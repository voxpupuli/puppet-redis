RSpec.configure do |c|
  c.mock_with :mocha
end

require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

def manifest_vars
  vars = {}

  case facts[:osfamily].to_s
  when 'RedHat'
    vars[:package_name] = 'redis'
    vars[:service_name] = 'redis'
    vars[:config_file] = '/etc/redis.conf'
    vars[:config_file_orig] = '/etc/redis.conf.puppet'
  when 'FreeBSD',
    vars[:package_name] = 'redis'
    vars[:service_name] = 'redis'
    vars[:config_file] = '/usr/local/etc/redis.conf'
    vars[:config_file_orig] = '/usr/local/etc/redis.conf.puppet'
  when 'Debian'
    vars[:package_name] = 'redis-server'
    vars[:service_name] = 'redis-server'
    vars[:config_file] = '/etc/redis/redis.conf'
    vars[:config_file_orig] = '/etc/redis/redis.conf.puppet'
  when 'Archlinux'
    vars[:package_name] = 'redis'
    vars[:service_name] = 'redis'
    vars[:config_file] = '/etc/redis/redis.conf'
    vars[:config_file_orig] = '/etc/redis/redis.conf.puppet'
  end

  vars
end

if ENV['DEBUG']
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
end

add_custom_fact :service_provider, (lambda do |_os, facts|
  case facts[:osfamily].downcase
  when 'archlinux'
    'systemd'
  when 'darwin'
    'launchd'
  when 'debian'
    'systemd'
  when 'freebsd'
    'freebsd'
  when 'gentoo'
    'openrc'
  when 'openbsd'
    'openbsd'
  when 'redhat'
    facts[:operatingsystemrelease].to_i >= 7 ? 'systemd' : 'redhat'
  when 'suse'
    facts[:operatingsystemmajrelease].to_i >= 12 ? 'systemd' : 'redhat'
  when 'windows'
    'windows'
  else
    'init'
  end
end)

RSpec.configure do |c|
  # getting the correct facter version is tricky. We use facterdb as a source to mock facts
  # see https://github.com/camptocamp/facterdb
  # people might provide a specific facter version. In that case we use it.
  # Otherwise we need to match the correct facter version to the used puppet version.
  # as of 2019-10-31, puppet 5 ships facter 3.11 and puppet 6 ships facter 3.14
  # https://puppet.com/docs/puppet/5.5/about_agent.html
  c.default_facter_version = if ENV['FACTERDB_FACTS_VERSION']
                               ENV['FACTERDB_FACTS_VERSION']
                             else
                               Gem::Dependency.new('', ENV['PUPPET_VERSION']).match?('', '5') ? '3.11.0' : '3.14.0'
                             end

  # Coverage generation
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
