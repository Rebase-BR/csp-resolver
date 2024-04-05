# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../examples/sculpture'

RSpec.describe CSP::Examples::Sculpture do
  describe '#call' do
    it 'returns the solution for the problem' do
      expect(described_class.new.call).to eq([{ 'A' => 2, 'B' => 1, 'C' => 1 }])
    end
  end
end
