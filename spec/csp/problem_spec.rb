# frozen_string_literal: true

require 'csp/problem'

RSpec.describe CSP::Problem do
  describe 'initialization' do
    it 'defaults to empty values and min solution' do
      csp = described_class.new

      expect(csp).to have_attributes(
        class: described_class,
        variables: [],
        domains: {},
        constraints: {},
        max_solutions: 1,
        ordering_algorithm: nil,
        filtering_algorithm: nil
      )
    end

    context 'when has variables and domains matching' do
      it 'initializes them and sets constraints for variables' do
        variable = double('Variable')
        variables = [variable]
        domains = { variable => [1, 2, 3] }
        constraints = { variable => [] }
        max_solutions = 2

        csp = described_class.new(variables:, domains:, max_solutions:)

        expect(csp).to have_attributes(
          class: described_class,
          variables:,
          domains:,
          constraints:,
          max_solutions:
        )
      end
    end

    context 'when variable does not have domains' do
      it 'raises an error' do
        variable = double('Variable')
        variables = [variable]
        domains = {}

        expect { described_class.new(variables:, domains:) }
          .to raise_error(
            described_class::MissingDomain,
            "Variable #{variable} does not have a domain assigned"
          )
      end
    end
  end

  describe '#solve' do
    it 'returns a list of solutions' do
      csp = described_class.new(domains: spy, variables: spy)
      algorithm = instance_double(
        CSP::Algorithms::Backtracking,
        backtracking: { solution: true }
      )

      allow(CSP::Algorithms::Backtracking)
        .to receive(:new)
        .with(
          problem: csp,
          ordering_algorithm: nil,
          filtering_algorithm: nil,
          max_solutions: 1
        )
        .and_return algorithm

      expect(csp.solve).to eq([{ solution: true }])
    end

    it 'calls backtracking without assignment' do
      csp = described_class.new(domains: spy, variables: spy)
      algorithm = instance_double(
        CSP::Algorithms::Backtracking,
        backtracking: { solution: true }
      )

      allow(CSP::Algorithms::Backtracking)
        .to receive(:new)
        .with(
          problem: csp,
          ordering_algorithm: nil,
          filtering_algorithm: nil,
          max_solutions: 1
        )
        .and_return algorithm

      csp.solve

      expect(algorithm).to have_received(:backtracking).with({})
    end

    it 'returns solutions without nil values' do
      csp = described_class.new(domains: spy, variables: spy)
      algorithm = instance_double(CSP::Algorithms::Backtracking, backtracking: nil)

      allow(CSP::Algorithms::Backtracking)
        .to receive(:new)
        .with(
          problem: csp,
          ordering_algorithm: nil,
          filtering_algorithm: nil,
          max_solutions: 1
        )
        .and_return algorithm

      expect(csp.solve).to be_empty
      expect(algorithm).to have_received(:backtracking).with({})
    end
  end

  describe '#add_constraint' do
    it 'adds a constraint to variable' do
      variable = double('Variable')
      constraint = double('Constraint', variables: [variable])

      csp = described_class.new(domains: spy, variables: [variable])

      expect(csp.add_constraint(constraint)).to eq true
      expect(csp.constraints).to include(variable => [constraint])
    end

    context 'when multiple variables' do
      it 'maps the constraint for each one' do
        variable = double('Variable')
        variable2 = double('Variable')
        variables = [variable, variable2]
        constraint = double('Constraint', variables:)

        csp = described_class.new(domains: spy, variables:)

        expect(csp.add_constraint(constraint)).to eq true
        expect(csp.constraints).to include(variable => [constraint])
        expect(csp.constraints).to include(variable2 => [constraint])
      end
    end

    context 'when constraint has a variable that does not exists in CSP' do
      it 'raises an error' do
        variable = double('Variable')
        constraint = double('Constraint', variables: [variable])

        csp = described_class.new(domains: spy, variables: spy)

        expect { csp.add_constraint(constraint) }
          .to raise_error described_class::MissingVariable,
                          "Constraint's variable doesn't exists in CSP"
      end
    end
  end

  describe '#add_ordering' do
    it 'sets the ordering algorithm for CSP' do
      ordering_algorithm = instance_double(CSP::Algorithms::Ordering::NoOrder)
      csp = described_class.new

      csp.add_ordering(ordering_algorithm)

      expect(csp).to have_attributes(ordering_algorithm:)
    end
  end

  describe '#add_filtering' do
    it 'sets the filtering algorithm for CSP' do
      filtering_algorithm = instance_double(CSP::Algorithms::Filtering::NoFilter)
      csp = described_class.new

      csp.add_filtering(filtering_algorithm)

      expect(csp).to have_attributes(filtering_algorithm:)
    end
  end
end
