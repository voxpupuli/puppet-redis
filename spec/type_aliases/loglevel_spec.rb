# frozen_string_literal: true

require 'spec_helper'

describe 'Redis::LogLevel' do
  it { is_expected.to allow_values('debug', 'verbose', 'notice', 'warning') }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value('') }
end
