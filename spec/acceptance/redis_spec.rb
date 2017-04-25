require 'spec_helper_acceptance'

describe 'redis' do

  context 'set show_diff' do
    shell('puppet config set show_diff true', { :acceptable_exit_codes => [0,1] })
  end

  case fact('osfamily')
  when 'Debian'
    redis_name = 'redis-server'
  else
    redis_name = 'redis'
  end

  it 'should run successfully' do
    pp = <<-EOS
    Exec {
      path => [ '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', ]
    }

    class { '::redis':
      manage_repo => true,
    }
    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  it 'should return a fact' do
    pp = <<-EOS
    notify{"Redis Version: ${::redis_server_version}":}
    EOS

    # Check output for fact string
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stdout).to match(/Redis Version: [\d+.]+/)
    end
  end

  describe package(redis_name) do
    it { should be_installed }
  end

  describe service(redis_name) do
    it { should be_running }
  end

  context 'redis should respond to ping command' do
    describe command('redis-cli ping') do
      its(:stdout) { should match /PONG/ }
    end
  end
end
