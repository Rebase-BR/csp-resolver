# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../examples/sculpture'

RSpec.describe CSP::Examples::Sculpture::MustBeInSameRoomConstraint do
  describe '#satisfies?' do
    context 'when variables have equal values in the assignment' do
      it 'retuns true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 3 })

        expect(satisfies).to eq true
      end
    end

    context 'when variables not have equal values in the assigment' do
      it 'retuns false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2]
        constraint = described_class.new(variables)
        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => 3 })

        expect(satisfies).to eq false
      end
    end

    context 'when any variable is nil in the assigment' do
      it 'return true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1 })

        expect(satisfies).to eq true
      end
    end

    context 'when any variable has the nil value in the assigment' do
      it 'return true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => nil })

        expect(satisfies).to eq true
      end
    end
  end
end
