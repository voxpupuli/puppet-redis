require 'spec_helper_acceptance'

describe 'redisget() function' do

  it 'should run successfully' do
    pp = <<-EOS
    Exec {
      path => [ '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin', ]
    }

    class { '::redis':
      manage_repo => true,
    }

    package { 'redis-rubygem' :
      ensure   => installed,
      name     => 'redis',
      provider => 'puppet_gem',
    }

    EOS

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)

    shell('redis-cli SET mykey "Hello"') do |result|
      expect(result.stdout).to match('OK')
    end

    shell('redis-cli GET mykey') do |result|
      expect(result.stdout).to match('Hello')
    end
  end

  it 'should return a value from MyKey with the redisget() function' do
    pp = <<-EOS
    $mykey = redisget('mykey', 'redis://127.0.0.1:6379')

    notify{"mykey value: ${mykey}":}
    EOS

    # Check output for fact string
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stdout).to match(/mykey value: Hello/)
    end
  end

  it 'should return an empty string when value not present with redisget() function' do
    pp = <<-EOS
    $foo_key = redisget('foo', 'redis://127.0.0.1:6379')

    if empty($foo_key){
      notify{"foo_key value was empty string":}
    }
    EOS

    # Check output for fact string
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stdout).to match(/foo_key value was empty string/)
    end
  end

end
