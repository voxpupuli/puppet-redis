require 'spec_helper'

describe 'redis::administration' do
  context 'should set kernel and system values' do
    it do
      is_expected.to contain_sysctl('vm.overcommit_memory').with(
        'ensure' => 'present',
        'value' => '1'
      )
    end

    it do
      is_expected.to contain_sysctl('net.core.somaxconn').with(
        'ensure' => 'present',
        'value' => '65535'
      )
    end
  end
end
