require 'spec_helper_acceptance'

describe 'redis-cli task' do
  subject do
    on(master, "bolt task run --modulepath /etc/puppetlabs/code/modules --targets localhost #{task_name} #{params}", acceptable_exit_codes: [0, 1]).stdout
  end

  let(:task_name) { 'redis::redis_cli' }

  it 'install redis-cli with the class' do
    pp = <<-EOS
    include redis
    EOS

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe 'ping' do
    let(:params) { 'command="ping"' }

    it 'execute ping' do
      is_expected.to match(%r{{\s*"status":\s*"PONG"\s*}})
      is_expected.to match(%r{Ran on 1 target in .+ sec})
    end
  end

  describe 'security' do
    describe 'command with semi colon' do
      let(:params) { 'command="ping; cat /etc/passwd"' }

      it 'stops script injections and escapes' do
        is_expected.to match(%r!{\s*"status":\s*"ERR unknown command ('|`)ping; cat /etc/passwd('|`)!)
        is_expected.to match(%r{Ran on 1 target in .+ sec})
      end
    end

    describe 'command with double ampersand' do
      let(:params) { 'command="ping && cat /etc/passwd"' }

      it 'stops script injections and escapes' do
        is_expected.to match(%r!{\s*"status":\s*"ERR unknown command ('|`)ping && cat /etc/passwd('|`)!)
        is_expected.to match(%r{Ran on 1 target in .+ sec})
      end
    end
  end
end
