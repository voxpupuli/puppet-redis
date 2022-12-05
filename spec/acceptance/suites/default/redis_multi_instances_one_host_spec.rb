# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis::instance example' do
  # TODO: SELinux
  # semanage port --add --type redis_port_t --proto tcp 6380-6382
  # Label /run/redis-server-\d+(/.+)? as redis_var_run_t

  instances = [6379, 6380, 6381, 6382]

  config_path = case fact('os.family')
                when 'Debian'
                  '/etc/redis'
                when 'RedHat'
                  if fact('os.release.major').to_i >= 9
                    '/etc/redis'
                  else
                    '/etc'
                  end
                else
                  '/etc'
                end

  redis_name = case fact('os.family')
               when 'Debian'
                 'redis-server'
               else
                 'redis'
               end

  it 'runs successfully' do
    pp = <<-EOS
    $listening_ports = #{instances}

    class { '::redis':
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

    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe package(redis_name) do
    it { is_expected.to be_installed }
  end

  describe service(redis_name) do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  instances.each do |instance|
    describe file("/etc/systemd/system/redis-server-#{instance}.service") do
      its(:content) { is_expected.to match %r{redis-server-#{instance}.conf} }
    end

    describe service("redis-server-#{instance}") do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file("#{config_path}/redis-server-#{instance}.conf") do
      its(:content) { is_expected.to match %r{port #{instance}} }
    end

    context "redis instance #{instance} should respond to ping command" do
      describe command("redis-cli -h #{fact('networking.ip')} -p #{instance} ping") do
        its(:stdout) { is_expected.to match %r{PONG} }
      end
    end
  end
end
