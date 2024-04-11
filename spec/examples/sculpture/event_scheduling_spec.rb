# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../examples/event_scheduling'

RSpec.describe CSP::Examples::EventScheduling do
  describe '#call' do
    it 'returns the solution for the problem' do
      expect(described_class.new.call).to eq([{0=>0, 1=>1, 2=>2}])
    end
  end
end
