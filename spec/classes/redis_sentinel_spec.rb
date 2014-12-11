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

  end

end
