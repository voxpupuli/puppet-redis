require 'spec_helper'

describe 'redis' do
  context 'on Debian Wheezy' do
    let(:facts) do
      debian_wheezy_facts
    end

    context 'should set Wheezy specific values' do
      context 'should set redis rundir correctly to Wheezy requirements' do
        it { is_expected.to contain_file('/var/run/redis').with('mode' => '2755') }
        it { is_expected.to contain_file('/var/run/redis').with('group' => 'redis') }
      end
    end
  end
end
