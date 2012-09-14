require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe "redis" do

  let(:node) { 'redis' }
  let(:facts) { {:operatingsystem => 'Debian'} }
##  let(:pre_condition) {
##    "class { 'redis':; }"
##  }

  let(:title) { 'Verify parameters' }
  let(:params) {
    {
      :package_deps   => '_package_deps_',
      :package_ensure => '_package_ensure_',
      :package_name   => '_package_name_',
    }
  }

  it { should contain_package('_package_name_').with_ensure('_package_ensure_') }
 #it { should contain_package('_package_deps_').with_ensure('_package_ensure_') }
end

