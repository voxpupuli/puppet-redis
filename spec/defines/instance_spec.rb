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

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      let(:redis) do
        case facts['os']['family']
        when 'RedHat'
          (facts['os']['release']['major'].to_i > 9) ? 'valkey' : 'redis'
        else
          'redis'
        end
      end

      context 'with app2 title' do
        let(:title) { 'app2' }
        let(:config_file) do
          case facts['os']['family']
          when 'Debian', 'Archlinux', 'RedHat'
            "/etc/#{redis}/#{redis}-server-#{title}.conf"
          when 'FreeBSD'
            "/usr/local/etc/redis/redis-server-#{title}.conf"
          end
        end

        it do
          case facts['os']['family']
          when 'FreeBSD'
            is_expected.to contain_file("#{config_file}.puppet")
              .with_content(%r{^bind 127.0.0.1})
              .with_content(%r{^logfile /var/log/#{redis}/#{redis}-server-#{title}\.log})
              .with_content(%r{^dir /var/db/redis/#{redis}-server-#{title}})
              .with_content(%r{^unixsocket /var/run/#{redis}-server-#{title}/#{redis}\.sock})
          else
            is_expected.to contain_file("#{config_file}.puppet")
              .with_content(%r{^bind 127.0.0.1})
              .with_content(%r{^logfile /var/log/#{redis}/#{redis}-server-#{title}\.log})
              .with_content(%r{^dir /var/lib/#{redis}/#{redis}-server-#{title}})
              .with_content(%r{^unixsocket /var/run/#{redis}-server-#{title}/#{redis}\.sock})
          end
        end

        it do
          case facts['os']['family']
          when 'FreeBSD'
            is_expected.to contain_file("/var/db/redis/#{redis}-server-#{title}")
          else
            is_expected.to contain_file("/var/lib/#{redis}/#{redis}-server-#{title}")
          end
        end

        it do
          case facts['os']['family']
          when 'FreeBSD'
            # skip systemd tests on FreeBSD
          else
            is_expected.to contain_file("/etc/systemd/system/#{redis}-server-#{title}.service")
              .with_content(%r{ExecStart=/usr/bin/#{redis}-server #{config_file}})
          end
        end

        it do
          case facts['os']['family']
          when 'FreeBSD'
            # skip systemd tests on FreeBSD
          else
            is_expected.to contain_service("#{redis}-server-#{title}.service").with_ensure(true).with_enable(true)
          end
        end
      end

      context 'with custom options' do
        let(:title) { 'default' }
        let(:params) do
          {
            config_file_orig: '/tmp/myorig.conf',
            custom_options: { 'myoption' => 'avalue', 'anotheroption' => 'anothervalue' },
          }
        end

        it do
          is_expected.to contain_file('/tmp/myorig.conf')
            .with_content(%r{^bind 127.0.0.1})
            .with_content(%r{^myoption avalue})
            .with_content(%r{^anotheroption anothervalue})
        end
      end
    end
  end
end
