require 'spec_helper'

describe 'redis', :type => :class do
  describe 'without parameters' do
    let (:facts) { debian_facts }

    it { should create_class('redis') }
    it { should include_class('redis::preinstall') }
    it { should include_class('redis::install') }
    it { should include_class('redis::config') }
    it { should include_class('redis::service') }

    it { should contain_package('redis-server').with_ensure('present') }

    it { should contain_file('/etc/redis.conf').with(
        'ensure' => 'present'
      )
    }

    it { should contain_service('redis').with(
        'ensure'     => 'running',
        'enable'     => 'true',
        'hasrestart' => 'true',
        'hasstatus'  => 'true'
      )
    }
  end

  describe 'with parameter: config_dir' do
    let (:facts) { debian_facts }
    let (:params) { { :config_dir => '_VALUE_' } }

    it { should contain_file('_VALUE_').with_ensure('directory') }
  end

  describe 'with parameter: config_dir_mode' do
    let (:facts) { debian_facts }
    let (:params) { { :config_dir_mode => '_VALUE_' } }

    it { should contain_file('/etc/redis').with_mode('_VALUE_') }
  end

  describe 'with parameter: config_file_mode' do
    let (:facts) { debian_facts }
    let (:params) { { :config_file_mode => '_VALUE_' } }

    it { should contain_file('/etc/redis.conf').with_mode('_VALUE_') }
  end

  describe 'with parameter: config_group' do
    let (:facts) { debian_facts }
    let (:params) { { :config_group => '_VALUE_' } }

    it { should contain_file('/etc/redis').with_group('_VALUE_') }
  end

  describe 'with parameter: config_owner' do
    let (:facts) { debian_facts }
    let (:params) { { :config_owner => '_VALUE_' } }

    it { should contain_file('/etc/redis').with_owner('_VALUE_') }
  end

  describe 'with parameter: package_ensure' do
    let (:facts) { debian_facts }
    let (:params) { { :package_ensure => '_VALUE_' } }

    it { should contain_package('redis-server').with_ensure('_VALUE_') }
  end

  describe 'with parameter: package_name' do
    let (:facts) { debian_facts }
    let (:params) { { :package_name => '_VALUE_' } }

    it { should contain_package('_VALUE_') }
  end

  describe 'with parameter: service_enable' do
    let (:facts) { debian_facts }
    let (:params) { { :service_enable => true } }

    it { should contain_service('redis').with_enable(true) }
  end

  describe 'with parameter: service_ensure' do
    let (:facts) { debian_facts }
    let (:params) { { :service_ensure => '_VALUE_' } }

    it { should contain_service('redis').with_ensure('_VALUE_') }
  end

  describe 'with parameter: service_hasrestart' do
    let (:facts) { debian_facts }
    let (:params) { { :service_hasrestart => '_VALUE_' } }

    it { should contain_service('redis').with_hasrestart('_VALUE_') }
  end

  describe 'with parameter: service_hasstatus' do
    let (:facts) { debian_facts }
    let (:params) { { :service_hasstatus => '_VALUE_' } }

    it { should contain_service('redis').with_hasstatus('_VALUE_') }
  end
end

