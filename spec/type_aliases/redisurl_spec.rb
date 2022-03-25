# frozen_string_literal: true

require 'spec_helper'

describe 'Redis::RedisUrl' do
  it { is_expected.to allow_value('redis://localhost') }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value('') }
end
