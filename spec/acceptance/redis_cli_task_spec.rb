# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'redis-cli task' do
  subject do
    on(default, "bolt task run --modulepath /etc/puppetlabs/code/environments/production/modules --targets localhost #{task_name} #{params}", acceptable_exit_codes: [0, 1]).stdout
  end

  let(:task_name) { 'redis::redis_cli' }

  if bolt_supported?
    include_examples 'an idempotent resource' do
      let(:manifest) { 'include redis' }
    end

    describe 'ping' do
      let(:params) { 'command="ping"' }

      it 'execute ping' do
        is_expected.
          to match(%r{{\s*"status":\s*"PONG"\s*}}).
          and match(%r{Ran on 1 target in .+ sec})
      end
    end

    describe 'security' do
      describe 'command with semi colon' do
        let(:params) { 'command="ping; cat /etc/passwd"' }

        it 'stops script injections and escapes' do
          is_expected.
            to match(%r!{\s*"status":\s*"ERR unknown command ('|`)ping; cat /etc/passwd('|`)!).
            and match(%r{Ran on 1 target in .+ sec})
        end
      end

      describe 'command with double ampersand' do
        let(:params) { 'command="ping && cat /etc/passwd"' }

        it 'stops script injections and escapes' do
          is_expected.
            to match(%r!{\s*"status":\s*"ERR unknown command ('|`)ping && cat /etc/passwd('|`)!).
            and match(%r{Ran on 1 target in .+ sec})
        end
      end
    end
  end
end
