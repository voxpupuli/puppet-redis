source 'https://rubygems.org'

# special dependencies for Rubies < 2.0.0
# since there are still several OSes with it
gem 'rspec-core','~> 3.1.7' if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'nokogiri', '~> 1.5.0'  if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'rspec',     '~> 2.0'   if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'rake',      '~> 10.0'  if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'json',      '<= 1.8'   if RUBY_VERSION < '2.0.0'
gem 'json_pure', '<= 2.0.1' if RUBY_VERSION < '2.0.0'

puppetversion = ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : ['>= 3.2.1']
gem 'puppet', puppetversion

if puppetversion =~ /^3/
  ## rspec-hiera-puppet is puppet 3 only
  gem 'rspec-hiera-puppet', '>=1.0.0'
end

facterversion = ENV.key?('FACTER_VERSION') ? "~> #{ENV['FACTER_VERSION']}" : ['>= 1.7.1']

gem 'facter', facterversion

gem 'puppet-lint', '>=0.3.2'
gem 'rspec-puppet', '>=0.1.6'
gem 'puppetlabs_spec_helper', '>=0.4.1'

gem 'beaker-rspec'
gem 'bundler'
gem 'vagrant-wrapper'
