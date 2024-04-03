# frozen_string_literal: true

require 'csp/default_constraints'

RSpec.describe CSP::DefaultConstraints::AllDifferentConstraint do
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
    context 'when one assigment is equal to other one' do
      it 'return false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 3 })

        expect(satisfies).to eq false
      end
    end
    context 'when more than one assigment is equal to other one' do
      it 'return false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2, variable3]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 1 })

        expect(satisfies).to eq false
      end
    end
  end
end

RSpec.describe CSP::DefaultConstraints::UniqueConstraint do
  describe '#satisfies?' do
    context 'when the assigments are unique given certain variables' do
      it 'retuns true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => 2})

        expect(satisfies).to eq true
      end
    end
    context 'when the assigments are not unique given certain variables' do
      it 'return false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 3 })

        expect(satisfies).to eq false
      end
    end

    context 'when the assigments are not unique given certain variables' do
      it 'return false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 3 })

        expect(satisfies).to eq false
      end
    end
  end
end
