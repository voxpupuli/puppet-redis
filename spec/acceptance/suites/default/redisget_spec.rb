require 'spec_helper_acceptance'

describe 'redis::get() function' do
  it 'runs successfully' do
    pp = <<-EOS
    include redis

    package { 'redis-rubygem' :
      ensure   => '3.3.3',
      name     => 'redis',
      provider => 'puppet_gem',
    }
    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe command('redis-cli SET mykey "Hello"') do
    its(:stdout) { is_expected.to match(%r{OK}) }
  end

  describe command('redis-cli GET mykey') do
    its(:stdout) { is_expected.to match('Hello') }
  end

  context 'with mykey set to Hello' do
    it 'returns a value from MyKey with the redis::get() function' do
      pp = <<-EOS
      $mykey = redis::get('mykey', 'redis://127.0.0.1:6379')

      notify{"mykey value: ${mykey}":}
      EOS

      # Check output for function return value
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{mykey value: Hello})
      end
    end

    it 'returns a value from valid MyKey with the redis::get() function while specifying a default' do
      pp = <<-EOS
      $mykey = redis::get('mykey', 'redis://127.0.0.1:6379', 'default_value')

      notify{"mykey value: ${mykey}":}
      EOS

      # Check output for function return value
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{mykey value: Hello})
      end
    end

    it 'returns an empty string when value not present with redis::get() function' do
      pp = <<-EOS
      $foo_key = redis::get('foo', 'redis://127.0.0.1:6379')

      if empty($foo_key){
        notify{"foo_key value was empty string":}
      }
      EOS

      # Check output for function return value
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{foo_key value was empty string})
      end
    end

    it 'returns the specified default value when key not present with redis::get() function' do
      pp = <<-EOS
      $foo_key = redis::get('foo', 'redis://127.0.0.1:6379', 'default_value')

      notify { $foo_key: }
      EOS

      # Check output for function return value
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{default_value})
      end
    end

    it 'returns the specified default value when connection to redis server fails' do
      pp = <<-EOS
      # Bogus port for redis server
      $foo_key = redis::get('foo', 'redis://127.0.0.1:12345', 'default_value')

      notify { $foo_key: }
      EOS

      # Check output for function return value
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{default_value})
      end
    end

    it 'returns an error when specifying a non connectable redis server' do
      pp = <<-EOS
      # Bogus port for redis server
      $foo_key = redis::get('foo', 'redis://127.0.0.1:12345')

      notify { $foo_key: }
      EOS

      # Check output for error when can't connect to bogus redis
      apply_manifest(pp, acceptable_exit_codes: [1]) do |r|
        expect(r.stderr).to match(%r{Error connecting to Redis on 127.0.0.1:12345 \(Errno::ECONNREFUSED\)})
      end
    end
  end
end
