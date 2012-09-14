require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

RSpec.configure do |c|
  c.manifest_dir = File.join(fixture_path, '..', '..', 'tests')
  c.module_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  c.formatter = 'documentation'
  c.color = 'true'
end
