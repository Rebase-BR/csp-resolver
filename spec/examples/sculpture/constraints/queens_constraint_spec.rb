# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../examples/queen'

RSpec.describe CSP::Examples::Queen::QueensConstraint do
  describe '#satisfies?' do
    context 'when the assignment is valid' do
      columns = [0, 1, 2, 3]
      constraint = described_class.new(columns)
      it 'returns true' do
        expect(constraint.satisfies?({ 0 => 0, 1 => 2, 2 => 3, 3 => 1 })).to eq(true)
      end
    end

    context 'when the assignment is not valid' do
      columns = [0, 1, 2, 3]
      constraint = described_class.new(columns)
      it 'returns false' do
        expect(constraint.satisfies?({ 0 => 0, 1 => 2, 2 => 3, 3 => 3 })).to eq(false)
      end
    end
  end
end
