# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../examples/queen'

RSpec.describe CSP::Examples::Queen::QueensConstraint do
  describe '#satisfies?' do
    context 'when no two queens threaten each other' do
      columns = (0..8).to_a
      constraint = described_class.new(columns)

      it 'returns true' do
        expect(constraint.satisfies?({ 0 => 0, 1 => 4, 2 => 7, 3 => 5, 4 => 2, 5 => 6, 6 => 1, 7 => 3 })).to eq(true)
      end
    end

    context 'when two queens are on the same row' do
      columns = (0..8).to_a
      constraint = described_class.new(columns)

      it 'returns false' do
        expect(constraint.satisfies?({ 0 => 0, 1 => 1, 2 => 7, 3 => 5, 4 => 2, 5 => 6, 6 => 1, 7 => 3 })).to eq(false)
      end
    end

    context 'when two queens are on the same diagonal' do
      columns = (0..8).to_a
      constraint = described_class.new(columns)

      it 'returns false' do
        expect(constraint.satisfies?({ 0 => 0, 1 => 3, 2 => 6, 3 => 2, 4 => 5, 5 => 7, 6 => 4, 7 => 1 })).to eq(false)
      end
    end

    context 'with incomplete assignments' do
      it 'returns true' do
        columns = (0..8).to_a
        constraint = described_class.new(columns)

        expect(constraint.satisfies?({ 0 => 0, 1 => 3, 2 => 6 })).to eq true
      end
    end
  end
end
