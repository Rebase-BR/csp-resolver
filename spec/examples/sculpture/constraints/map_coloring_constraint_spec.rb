# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../examples/map_coloring'

RSpec.describe CSP::Examples::MapColoring::MapColoringConstraint do
  describe '#satisfies?' do

    context 'when both regions are assigned different colors' do
      it 'returns true' do
        assignment = {
          'Western Australia' => 'red',
          'Northern Territory' => 'blue'
        }
        constraint = described_class.new('Western Australia', 'Northern Territory')
        expect(constraint.satisfies?(assignment)).to eq true
      end
    end

    context 'when both regions are assigned the same color' do
      it 'returns false' do
        assignment = {
          'Western Australia' => 'blue',
          'Northern Territory' => 'blue'
        }
        constraint = described_class.new('Western Australia', 'Northern Territory')
        expect(constraint.satisfies?(assignment)).to eq false
      end
    end

    context 'when one of the regions is not assigned a color' do
      it 'returns true' do
        assignment = {
          'Western Australia' => 'blue'
          # 'Northern Territory' is not assigned
        }
        constraint = described_class.new('Western Australia', 'Northern Territory')
        expect(constraint.satisfies?(assignment)).to eq true
      end
    end

    context 'when neither of the regions are assigned a color' do
      it 'returns true' do
        assignment = {}
        constraint = described_class.new('Western Australia', 'Northern Territory')
        expect(constraint.satisfies?(assignment)).to eq true
      end
    end
  end
end
