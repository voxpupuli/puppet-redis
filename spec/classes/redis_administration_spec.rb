require 'spec_helper'

describe 'redis::administration' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:thp_control_package_name) do
        case facts[:operatingsystem]
        when 'Debian'
          'libhugetlbfs'
        when 'Ubuntu'
          'hugepages'
        when 'RedHat'
          'libhugetlbfs-utils'
        when 'CentOS'
          'libhugetlbfs-utils'
        when 'Archlinux'
          'libhugetlbfs'
        end
      end

      it { is_expected.to compile }

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

      it { is_expected.to contain_package(thp_control_package_name).with_ensure('present') }

      it {
        is_expected.to contain_class('systemd')
      }
      it { is_expected.to contain_systemd__unit_file('disable_thp.timer') }

      describe 'unit file' do
        let(:content) { catalogue.resource('systemd::unit_file', 'disable_thp.service').send(:parameters)[:content] }

        it { is_expected.to contain_systemd__unit_file('disable_thp.service') }
        it 'Description' do
          expect(content).to include('Description=Disables THP on boot')
        end
        it 'ExecStart' do
          expect(content).to include('ExecStart=/bin/hugeadm --thp-never')
        end
      end

    end
  end
end
