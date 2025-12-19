# frozen_string_literal: true

require 'spec_helper'

describe 'Redis::OOMScoreAdjust' do
  it { is_expected.to allow_values(1000, -1000, 0) }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value(1001) }
end
