require 'spec_helper'
require 'mock_redis'
require 'redis'

REDIS_URL='redis://localhost:6379'

describe 'redisget' do
  context 'should return nil if key does not exist' do
    before {
      mr = MockRedis.new
      Redis.stubs(:new).returns(mr)
      mr.set('nonexistent_key', nil)
    }
    it { is_expected.to run.with_params('nonexistent_key', REDIS_URL).and_return('') }
  end

  context 'should return the value of the specified key' do
    before {
      mr = MockRedis.new
      Redis.stubs(:new).returns(mr)
      mr.set('key', 'value')
    }
    it { is_expected.to run.with_params('key', REDIS_URL).and_return('value') }
  end

  describe 'with incorrect arguments' do
    context 'with no argument specified' do
      it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    end

    context 'with only one argument specified' do
      it { is_expected.to run.with_params('some_key').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    end

    context 'with more than two arguments specified' do
      it { is_expected.to run.with_params('too', 'many', 'args').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
    end
  end

  describe 'when an invalid type (non-string) is specified' do
    before(:each) {
      mr = MockRedis.new
      Redis.stubs(:new).returns(mr)
    }
    [{ 'ha' => 'sh'}, true, 1, ['an', 'array']].each do |p|
      context "specifing first parameter as <#{p}>" do
        it { is_expected.to run.with_params(p, REDIS_URL).and_raise_error(Puppet::ParseError, /wrong argument type/i) }
      end

      context "specifing second parameter as <#{p}>" do
        it { is_expected.to run.with_params('valid', p).and_raise_error(Puppet::ParseError, /wrong argument type/i) }
      end
    end
  end
end
