require 'spec_helper_acceptance'

describe 'redis::sentinel' do
  redis_name = case fact('osfamily')
               when 'Debian'
                 'redis-server'
               else
                 'redis'
               end

  it 'runs successfully' do
    pp = <<-EOS

    $master_name      = 'mymaster'
    $redis_master     = '127.0.0.1'
    $failover_timeout = 10000

    # We're testing with `manage_repo` true.  In redis-sentinel 5, the daemon has its own rundir
    if $::operatingsystem == 'Ubuntu' {
      $pidfile = '/var/run/sentinel/redis-sentinel.pid'
    } else {
      $pidfile = undef
    }

    class { 'redis':
      manage_repo => true,
    }
    ->
    class { 'redis::sentinel':
      master_name      => $master_name,
      redis_host       => $redis_master,
      failover_timeout => $failover_timeout,
      pid_file         => $pidfile,
    }
    EOS

    apply_manifest(pp, catch_failures: true)
  end

  describe package(redis_name) do
    it { is_expected.to be_installed }
  end

  describe service(redis_name) do
    it { is_expected.to be_running }
  end

  describe service('redis-sentinel') do
    it { is_expected.to be_running }
  end

  case fact('osfamily')
  when 'Debian'
    describe package('redis-sentinel') do
      it { is_expected.to be_installed }
    end
  end

  context 'redis should respond to ping command' do
    describe command('redis-cli ping') do
      its(:stdout) { is_expected.to match %r{PONG} }
    end
  end

  context 'redis-sentinel should return correct sentinel master' do
    describe command('redis-cli -p 26379 SENTINEL masters') do
      its(:stdout) { is_expected.to match %r{^mymaster} }
    end
  end
end
