# frozen_string_literal: true

require 'csp/problems/examples/sculpture'

RSpec.describe CSP::Problems::Sculpture::RoomLimitToOneConstraint do
  describe '#satisfies?' do
    context 'when only one variable in the assigment has the room value' do
      it 'retuns true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(room: 1, variables:)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => 2 })

        expect(satisfies).to eq true
      end
    end

    context 'when none variable in the assigment have the room value' do
      it 'return true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(room: 1, variables:)

        satisfies = constraint.satisfies?({ variable => 3, variable2 => 2, variable3 => 2 })

        expect(satisfies).to eq true
      end
    end

    context 'when atleast two variables in the assigment has the room value' do
      it 'retuns false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable]
        constraint = described_class.new(room: 1, variables:)
        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 2 })

        expect(satisfies).to eq false
      end
    end
  end
end
