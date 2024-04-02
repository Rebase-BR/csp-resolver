# frozen_string_literal: true

require 'csp/problems/examples/sculpture'

RSpec.describe CSP::Problems::Sculpture do
  describe '#call' do
    it 'returns the solution for the problem' do
      expect(described_class.new.call).to eq([{ 'A' => 2, 'B' => 1, 'C' => 1 }])
    end
  end
end
