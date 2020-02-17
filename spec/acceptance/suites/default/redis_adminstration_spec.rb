require 'spec_helper_acceptance'

# systcl settings are untestable in docker
describe 'redis::administration', unless: default['hypervisor'] =~ %r{docker} do
  it 'runs successfully' do
    pp = <<-EOS
    include redis
    include redis::administration
    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe file('/proc/sys/vm/overcommit_memory') do
    its(:content) { is_expected.to eq("1\n") }
  end

  describe file('/sys/kernel/mm/transparent_hugepage/enabled') do
    its(:content) { is_expected.to eq("always madvise [never]\n") }
  end

  describe file('/proc/sys/net/core/somaxconn') do
    its(:content) { is_expected.to eq("65535\n") }
  end

  describe command('timeout 1s redis-server --port 7777 --loglevel verbose') do
    its(:stderr) { is_expected.not_to match(%r{WARNING}) }
    its(:exit_status) { is_expected.to eq(124) }
  end
end
