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

      it do
        should include_class('redis')
        should include_class('redis::install')
        should include_class('redis::config')
      end
    end
  end

  deb_distros.each do |os|
    describe "on #{os}" do
      let(:facts) do
        {
          'operatingsystem' => os
        }
      end

      it do
        should include_class('redis')
        should include_class('redis::install')
        should include_class('redis::config')
      end
    end
  end
end

