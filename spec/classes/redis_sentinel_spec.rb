require 'spec_helper'

describe 'redis::sentinel', :type => :class do
  let (:facts) { debian_facts }

  describe 'without parameters' do
    it { should create_class('redis::sentinel') }

    it { should contain_file('/etc/redis/redis-sentinel.conf.puppet').with(
        'ensure' => 'present'
      )
    }

    it { should contain_file('/etc/redis/redis-sentinel.conf').with(
        'mode' => '0644'
      )
    }

    it { should contain_service('redis-sentinel').with(
        'ensure'     => 'running',
        'enable'     => 'true',
        'hasrestart' => 'true',
        'hasstatus'  => 'false'
      )
    }

  end

  describe 'with parameter: down_after' do
    let (:params) { { :down_after => 6000 } }

    it { should contain_file('/etc/redis/redis-sentinel.conf.puppet').with(
        'content' => /sentinel down-after-milliseconds mymaster 6000/
      )
    }
  end

end
