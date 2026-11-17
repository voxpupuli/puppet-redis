# frozen_string_literal: true

require 'spec_helper'

describe 'redis::administration' do
  context 'should set kernel and system values' do
    it do
      is_expected.to contain_sysctl('vm.overcommit_memory').with(
        'ensure' => 'present',
        'value' => '1',
      )
    end

    it do
      is_expected.to contain_sysctl('net.core.somaxconn').with(
        'ensure' => 'present',
        'value' => '65535',
      )
    end
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      if os_facts['os']['family'] == 'FreeBSD'
        it { is_expected.not_to contain_sysctl('vm.overcommit_memory') }
        it { is_expected.not_to contain_sysctl('net.core.somaxconn') }
        it { is_expected.to contain_sysctl('kern.ipc.soacceptqueue').with_ensure('present').with_value('65535') }
      else
        it { is_expected.to contain_sysctl('vm.overcommit_memory').with_ensure('present').with_value('1') }
        it { is_expected.to contain_sysctl('net.core.somaxconn').with_ensure('present').with_value('65535') }
      end

      context 'with somaxconn 0' do
        let(:params) { { somaxconn: 0 } }

        it { is_expected.not_to contain_sysctl('net.core.somaxconn') }
        it { is_expected.not_to contain_sysctl('kern.ipc.soacceptqueue') }
      end
    end
  end
end
