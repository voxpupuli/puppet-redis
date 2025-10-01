# frozen_string_literal: true

require 'spec_helper_acceptance'

if hosts.length >= 3
  describe 'configuring master and slave redis hosts' do
    let(:master_ip_address) do
      # hosts_as('master').inject({}) do |memo,host|
      #   memo[host] = fact_on host, "ipaddress_enp0s8"
      # end
      '10.255.33.129' # hardcoding as vagrant ip for now
    end

    redis = case fact('os.family')
            when 'RedHat'
              fact('os.release.major').to_i > 9 ? 'valkey' : 'redis'
            else
              'redis'
            end

    hosts_as('master').each do |host|
      context "should be able to configure a host as master on #{host}" do
        it 'works idempotently with no errors' do
          pp = <<-EOS
          # Stop firewall so we can easily connect
          service {'firewalld':
            ensure => 'stopped',
          }

          class { 'redis':
            bind        => '#{master_ip_address}',
            requirepass => 'foobared',
          }
          EOS
          apply_manifest_on(host, pp, catch_failures: true)

          command_to_check = "#{redis}-cli -h #{master_ip_address} -a foobared info replication"

          on host, command_to_check do
            expect(stdout).to match(%r{^role:master})
          end
        end
      end
    end

    hosts_as('slave').each do |host|
      context "should be able to configure a host as master on #{host}" do
        it 'works idempotently with no errors' do
          pp = <<-EOS
          class { 'redis':
            bind        => '127.0.0.1',
            masterauth  => 'foobared',
            slaveof     => '#{master_ip_address} 6379'
          }

          EOS
          apply_manifest_on(host, pp, catch_failures: true)

          on host, "#{redis}-cli -h $(facter ipaddress_enp0s8) info replication" do
            expect(stdout).to match(%r{^role:slave})
          end
        end
      end
    end

    hosts_as('master').each do |host|
      context "should be able to configure a host as master on #{host}" do
        it 'works idempotently with no errors' do
          command_to_check = "#{redis}-cli -h #{master_ip_address} -a foobared info replication"

          sleep(5)

          on host, command_to_check do
            expect(stdout).to match(%r{^connected_slaves:2})
          end
        end
      end
    end
  end
end
