# frozen_string_literal: true

require 'csp/problems/examples/sculpture'

RSpec.describe CSP::Problems::Sculpture::CannotBeInSameRoomConstraint do
  describe '#satisfies?' do
    context 'when all assignments are different' do
      it 'retuns true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => 3 })

        expect(satisfies).to eq true
      end
    end

    context 'when any two assignments are equal' do
      it 'retuns false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(variables)
        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 3 })

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

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => nil })

        expect(satisfies).to eq true
      end
    end
  end
end
