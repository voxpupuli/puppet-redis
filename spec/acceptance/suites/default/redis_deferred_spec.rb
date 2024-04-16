# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis with deferred password' do
  include_examples 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'redis':
        manage_repo    => true,
        redis_apt_repo => true,
        port           => 10001,
        requirepass    => Deferred('inline_epp',['<%= $pass %>',{'pass' => 'topsecret'}]),
      }
      PUPPET
    end
  end

  describe command('redis-cli -p 10001 -a topsecret ping') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{PONG} }
  end

  describe command('redis-cli -p 10001 -a nonsense ping') do
    its(:stdout) { is_expected.not_to match %r{PONG} }
  end
end
