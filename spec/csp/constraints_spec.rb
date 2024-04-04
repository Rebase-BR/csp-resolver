# frozen_string_literal: true

require 'csp/constraints'

RSpec.describe CSP::Constraints::AllDifferentConstraint do
  describe '#satisfies?' do
    context 'when all assignments are different' do
      it 'retuns true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        constraint = described_class.new

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => 3 })

        expect(satisfies).to eq true
      end
    end
    context 'when one assigment is equal to other one' do
      it 'return false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        constraint = described_class.new

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 3 })

        expect(satisfies).to eq false
      end
    end
    context 'when more than one assigment is equal to other one' do
      it 'return false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        constraint = described_class.new

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 1 })

        expect(satisfies).to eq false
      end
    end
  end
end

RSpec.describe CSP::Constraints::UniqueConstraint do
  describe '#satisfies?' do
    context 'when the assigments are unique given certain variables' do
      it 'retuns true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable2]
        constraint = described_class.new(variables)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => 2 })

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

RSpec.describe CSP::Constraints::CustomConstraint do
  describe '#satisfies?' do
    context 'when given a block and an assigment that satisfies the custom constraint' do
      it 'retuns true' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable3]

        block = proc { |var, var3| var == var3 }
        constraint = described_class.new(variables, block)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 2, variable3 => 1 })

        expect(satisfies).to eq true
      end
    end
    context 'when given a block and an assigment that not satisfies the custom constraint' do
      it 'return false' do
        variable = double('Variable')
        variable2 = double('Variable')
        variable3 = double('Variable')
        variables = [variable, variable3]

        block = proc { |var, var3| var == var3 }
        constraint = described_class.new(variables, block)

        satisfies = constraint.satisfies?({ variable => 1, variable2 => 1, variable3 => 3 })

        expect(satisfies).to eq false
      end
    end
  end
end
