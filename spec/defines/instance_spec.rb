require 'spec_helper'

describe 'redis::instance', :type => :define do
  let :pre_condition do
    'class { "redis":
      default_install => false,
    }'
  end
  let :title do
    'redis2'
  end
  describe 'os-dependent items' do
    context "on Ubuntu systems" do
      context '14.04' do
        let(:facts) {
          ubuntu_1404_facts
        }
        it { should contain_file('/etc/redis/redis.conf.puppet.redis2').with('content' => /^bind 127.0.0.1/) }
        it { should contain_file('/etc/redis/redis.conf.puppet.redis2').with('content' => /^logfile \/var\/log\/redis\/redis-server-redis2.log/) }
        it { should contain_service('redis2').with_ensure('running') }
        it { should contain_file('/etc/init.d/redis2').with_content(/DAEMON_ARGS=\/etc\/redis\/redis.conf.redis2/) }
        it { should contain_file('/etc/init.d/redis2').with_content(/PIDFILE=\/var\/run\/redis\/redis-server-redis2.pid/) }
      end
      context '16.04' do
        let(:facts) {
          ubuntu_1604_facts.merge({
            :service_provider => 'systemd',
          })
        }
        it { should contain_file('/etc/redis/redis.conf.puppet.redis2').with('content' => /^bind 127.0.0.1/) }
        it { should contain_file('/etc/redis/redis.conf.puppet.redis2').with('content' => /^logfile \/var\/log\/redis\/redis-server-redis2.log/) }
        it { should contain_service('redis2').with_ensure('running') }
        it { should contain_file('/etc/systemd/system/redis2.service').with_content(/ExecStart=\/usr\/bin\/redis-server \/etc\/redis\/redis.conf.redis2/) }
      end
    end
    context "on CentOS systems" do
      context '6' do
        let(:facts) {
          centos_6_facts
        }
        it { should contain_file('/etc/redis.conf.puppet.redis2').with('content' => /^bind 127.0.0.1/) }
        it { should contain_file('/etc/redis.conf.puppet.redis2').with('content' => /^logfile \/var\/log\/redis\/redis-server-redis2.log/) }
        it { should contain_service('redis2').with_ensure('running') }
        it { should contain_file('/etc/init.d/redis2').with_content(/REDIS_CONFIG="\/etc\/redis.conf.redis2"/) }
        it { should contain_file('/etc/init.d/redis2').with_content(/pidfile="\/var\/run\/redis\/redis-server-redis2.pid"/) }
      end
      context '7' do
        let(:facts) {
          centos_7_facts.merge({
            :service_provider => 'systemd',
          })
        }
        it { should contain_file('/etc/redis.conf.puppet.redis2').with('content' => /^bind 127.0.0.1/) }
        it { should contain_file('/etc/redis.conf.puppet.redis2').with('content' => /^logfile \/var\/log\/redis\/redis-server-redis2.log/) }
        it { should contain_service('redis2').with_ensure('running') }
        it { should contain_file('/etc/systemd/system/redis2.service').with_content(/ExecStart=\/usr\/bin\/redis-server \/etc\/redis.conf.redis2/) }
      end
    end
  end
end
