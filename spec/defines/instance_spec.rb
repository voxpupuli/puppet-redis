# frozen_string_literal: true

require 'spec_helper'

describe 'redis::instance' do
  let :pre_condition do
    <<-PUPPET
    class { 'redis':
      default_install => false,
    }
    PUPPET
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with app2 title' do
        let(:title) { 'app2' }
        let(:config_file) do
          case facts[:os]['family']
          when 'RedHat'
            if facts[:os]['release']['major'].to_i > 8
              '/etc/redis/redis-server-app2.conf'
            else
              '/etc/redis-server-app2.conf'
            end
          when 'FreeBSD'
            '/usr/local/etc/redis/redis-server-app2.conf'
          when 'Debian', 'Archlinux'
            '/etc/redis/redis-server-app2.conf'
          end
        end

        it do
          is_expected.to contain_file("#{config_file}.puppet").
            with_content(%r{^bind 127.0.0.1}).
            with_content(%r{^logfile /var/log/redis/redis-server-app2\.log}).
            with_content(%r{^dir /var/lib/redis/redis-server-app2}).
            with_content(%r{^unixsocket /var/run/redis-server-app2/redis\.sock})
        end

        it { is_expected.to contain_file('/var/lib/redis/redis-server-app2') }

        it do
          is_expected.to contain_file('/etc/systemd/system/redis-server-app2.service').
            with_content(%r{ExecStart=/usr/bin/redis-server #{config_file}})
        end

        it { is_expected.to contain_service('redis-server-app2.service').with_ensure(true).with_enable(true) }
      end
    end
  end
end
