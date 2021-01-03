require 'spec_helper'

describe 'redis::administration' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:thp_control_package_name) do
        case facts[:osfamily]
        when 'Debian'
          'libhugetlbfs'
        when 'Ubuntu'
          'hugepagesz'
        when 'RedHat'
          'libhugetlbfs-utils'
        when 'Archlinux'
          'libhugetlbfs'
        end
      end
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

      it {
        is_expected.to contain_file('/etc/systemd/system/disable_thp.service').
          with_ensure('file').
          with_mode('0644').
          with_owner('root').
          with_content(%r{ExecStart=/bin/hugeadm --thp-never})
      }

      it { is_expected.to contain_package(thp_control_package_name).with_ensure('present') }

      it do
        is_expected.to contain_service('disable_thp').with(
          'ensure' => 'false',
          'enable' => 'true',
        )
      end

      it do
        is_expected.to contain_exec('systemd run_once disable_thp').with(
          'command' => '/usr/bin/systemctl start disable_thp.service',
          'refreshonly' => 'true',
        )
      end

    end
  end
end
