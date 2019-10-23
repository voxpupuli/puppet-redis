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
    vars[:ppa_repo] = nil
  when 'FreeBSD',
    vars[:package_name] = 'redis'
    vars[:service_name] = 'redis'
    vars[:config_file] = '/usr/local/etc/redis.conf'
    vars[:config_file_orig] = '/usr/local/etc/redis.conf.puppet'
    vars[:ppa_repo] = nil
  when 'Debian'
    vars[:package_name] = 'redis-server'
    vars[:service_name] = 'redis-server'
    vars[:config_file] = '/etc/redis/redis.conf'
    vars[:config_file_orig] = '/etc/redis/redis.conf.puppet'
    vars[:ppa_repo] = 'ppa:chris-lea/redis-server'
  when 'Archlinux'
    vars[:package_name] = 'redis'
    vars[:service_name] = 'redis'
    vars[:config_file] = '/etc/redis/redis.conf'
    vars[:config_file_orig] = '/etc/redis/redis.conf.puppet'
    vars[:ppa_repo] = nil
  end

  vars
end

def redis_service_name(service_name: 'default')
  case service_name.to_s
  when 'default'
    manifest_vars[:service_name]
  else
    "#{manifest_vars[:service_name]}-#{service_name}"
  end
end

def redis_service_file(service_name: redis_service_name, service_provider: nil)
  case service_provider.to_s
  when 'systemd'
    "/etc/systemd/system/#{service_name}.service"
  else
    "/etc/init.d/#{service_name}"
  end
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

# Include code coverage report for all our specs
at_exit { RSpec::Puppet::Coverage.report! }
