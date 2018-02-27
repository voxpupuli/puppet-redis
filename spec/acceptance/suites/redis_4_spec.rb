require 'spec_helper_acceptance'

# sticking to just the centos remi 4 repo for now
describe 'redis::instance', :if => (fact('operatingsystem') == 'CentOS') do
  it 'should run successfully' do
    pending "Needs beaker suites to work"

    pp = <<-EOS
    Exec {
      path => $::path,
    }

    yumrepo { 'remi':
      descr      => 'remi repo',
      mirrorlist => 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror',
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi',
      before     => Class['redis']
    }
    -> class { '::redis':
      package_ensure => '4.0.1',
      manage_repo    => true,
    }
    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe package('redis') do
    it { should be_installed }
  end

  it 'should return a fact' do
    pp = <<-EOS
    notify{"Redis Version: ${::redis_server_version}":}
    EOS

    # Check output for fact string
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stdout).to match(/Redis Version: [4.]+/)
    end
  end

  describe package('redis') do
    it { should be_installed }
  end

  describe service('redis') do
    it { should be_running }
  end

  context 'redis should respond to ping command' do
    describe command('redis-cli ping') do
      its(:stdout) { should match /PONG/ }
    end
  end
end
