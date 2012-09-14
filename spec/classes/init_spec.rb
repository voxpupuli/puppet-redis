require 'spec_helper'

describe 'redis' do
  let(:title) { 'redis' }
  let(:facts) {
    {
      :environment => 'development',
    }
  }

  rpm_distros = [ 'RedHat', 'CentOS', 'Scientific', 'OEL', 'Amazon' ]
  deb_distros = [ 'Debian', 'Ubuntu' ]

  rpm_distros.each do |os|
    describe "on #{os}" do
      let(:facts) do
        {
          'operatingsystem' => os
        }
      end

      it { should include_class('redis') }
      it { should include_class('redis::install') }
      it { should include_class('redis::config') }
    end
  end

  deb_distros.each do |os|
    describe "on #{os}" do
      let(:facts) do
        {
          'operatingsystem' => os
        }
      end

      it { should include_class('redis') }
      it { should include_class('redis::install') }
      it { should include_class('redis::config') }
    end
  end
end

