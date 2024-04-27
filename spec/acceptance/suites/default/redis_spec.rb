# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis' do
  redis_name = fact('os.family') == 'Debian' ? 'redis-server' : 'redis'

  include_examples 'an idempotent resource' do
    let(:manifest) { 'include redis' }
  end

  it 'returns a fact' do
    pp = <<-EOS
    notify{"Redis Version: ${::redis_server_version}":}
    EOS

    # Check output for fact string
    apply_manifest(pp, catch_failures: true) do |r|
      expect(r.stdout).to match(%r{Redis Version: [\d+.]+})
    end
  end

  specify { expect(package(redis_name)).to be_installed }
  specify { expect(service(redis_name)).to be_running }

  specify 'redis should respond to ping command' do
    expect(command('redis-cli ping')).
      to have_attributes(stdout: %r{PONG})
  end

  it 'runs successfully when using Redis apt repository', if: (fact('os.family') == 'Debian') do
    pp = <<-EOS
      class { 'redis':
        manage_repo    => true,
        redis_apt_repo => true,
      }
    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end
end
