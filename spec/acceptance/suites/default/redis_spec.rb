require 'spec_helper_acceptance'

describe 'redis' do
  redis_name = case fact('osfamily')
               when 'Debian'
                 'redis-server'
               else
                 'redis'
               end

  it 'runs successfully' do
    pp = <<-EOS
    include redis
    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
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

  describe package(redis_name) do
    it { is_expected.to be_installed }
  end

  describe service(redis_name) do
    it { is_expected.to be_running }
  end

  context 'redis should respond to ping command' do
    describe command('redis-cli ping') do
      its(:stdout) { is_expected.to match %r{PONG} }
    end
  end
end
