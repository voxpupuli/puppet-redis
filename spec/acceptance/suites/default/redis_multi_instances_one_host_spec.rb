# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis::instance example' do
  # TODO: SELinux
  # semanage port --add --type redis_port_t --proto tcp 6380-6382
  # Label /run/redis-server-\d+(/.+)? as redis_var_run_t

  instances = [6379, 6380, 6381, 6382]

  redis = case fact('os.family')
          when 'RedHat'
            fact('os.release.major').to_i > 9 ? 'valkey' : 'redis'
          else
            'redis'
          end

  config_path = case fact('os.family')
                when 'Debian'
                  "/etc/#{redis}"
                when 'RedHat'
                  fact('os.release.major').to_i >= 9 ? "/etc/#{redis}" : '/etc'
                else
                  '/etc'
                end

  redis_name = case fact('os.family')
               when 'Debian'
                 "#{redis}-server"
               else
                 redis
               end

  include_examples 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        $listening_ports = #{instances}

        class { 'redis':
          default_install => false,
          service_enable  => false,
          service_ensure  => 'stopped',
          protected_mode  => false,
          bind            => [],
        }

        $listening_ports.each |$port| {
          $port_string = sprintf('%d',$port)
          redis::instance { $port_string:
            service_enable => true,
            service_ensure => 'running',
            port           => $port,
            bind           => $facts['networking']['ip'],
            dbfilename     => "${port}-dump.rdb",
            appendfilename => "${port}-appendonly.aof",
            appendfsync    => 'always',
            require        => Class['Redis'],
          }
        }
      PUPPET
    end
  end

  specify { expect(package(redis_name)).to be_installed }

  specify do
    expect(service(redis_name)).not_to be_enabled
    expect(service(redis_name)).not_to be_running
  end

  instances.each do |instance|
    specify do
      expect(file("/etc/systemd/system/#{redis}-server-#{instance}.service")).
        to be_file.
        and have_attributes(content: include("#{redis}-server-#{instance}.conf"))
    end

    specify { expect(service("#{redis}-server-#{instance}")).to be_enabled.and be_running }

    specify do
      expect(file("#{config_path}/#{redis}-server-#{instance}.conf")).
        to be_file.
        and have_attributes(content: include("port #{instance}"))
    end

    specify "redis instance #{instance} should respond to ping command" do
      expect(command("#{redis}-cli -h #{fact('networking.ip')} -p #{instance} ping")).
        to have_attributes(stdout: %r{PONG})
    end
  end
end
