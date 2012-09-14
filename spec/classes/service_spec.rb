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
      :daemon_enable    => '_daemon_enable_',
      :daemon_ensure    => '_daemon_ensure_',
      :daemon_group     => '_daemon_group_',
      :daemon_hasstatus => '_daemon_hasstatus_',
      :daemon_name      => '_daemon_name_',
      :daemon_user      => '_daemon_user_',
    }
  }

  it do
    should contain_service('_daemon_name_').with(
      'ensure'    => '_daemon_ensure_',
      'enable'    => '_daemon_enable_',
      'hasstatus' => '_daemon_hasstatus_',
    )
  end
end

