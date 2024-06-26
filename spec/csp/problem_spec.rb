# frozen_string_literal: true

require 'spec_helper'

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
      it 'initialize and sets constraint for the variable' do
        variable = double('Variable', empty?: false)
        variables = [variable]
        domains = [1, 2, 3]
        constraints = { variable => [] }
        max_solutions = 2

        csp = described_class.new(max_solutions: max_solutions)
          .add_variable(variable, domains: domains)

        expect(csp).to have_attributes(
          class: described_class,
          variables: variables,
          domains: { variable => [1, 2, 3] },
          constraints: constraints,
          max_solutions: max_solutions
        )
      end
      context 'when has multiple variables' do
        it 'initializes them and sets constraints for variables' do
          variable = double('Variable', empty?: false)
          variable2 = double('Variable', empty?: false)
          variables = [variable, variable2]
          domains = [1, 2, 3]
          constraints = { variable => [], variable2 => [] }
          max_solutions = 2

          csp = described_class.new(max_solutions: max_solutions)
            .add_variable(variable, domains: domains)
            .add_variable(variable2, domains: domains)

          expect(csp).to have_attributes(
            class: described_class,
            variables: variables,
            domains: { variable => [1, 2, 3], variable2 => [1, 2, 3] },
            constraints: constraints,
            max_solutions: max_solutions
          )
        end
      end
    end
  end

  describe '#solve' do
    it 'returns a list of solutions' do
      csp = described_class.new
        .add_variable(double('Variable', empty?: false), domains: double('domains', empty?: false))
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
          lookahead_algorithm: nil,
          max_solutions: 1
        )
        .and_return algorithm

      expect(csp.solve).to eq([{ solution: true }])
    end

    it 'calls backtracking without assignment' do
      csp = described_class.new
        .add_variable(double('Variable', empty?: false), domains: double('domains', empty?: false))
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
          lookahead_algorithm: nil,
          max_solutions: 1
        )
        .and_return algorithm

      csp.solve

      expect(algorithm).to have_received(:backtracking).with({})
    end

    it 'returns solutions without nil values' do
      csp = described_class.new
        .add_variable(double('Variable', empty?: false), domains: double('domains', empty?: false))
      algorithm = instance_double(
        CSP::Algorithms::Backtracking,
        backtracking: nil
      )

      allow(CSP::Algorithms::Backtracking)
        .to receive(:new)
        .with(
          problem: csp,
          ordering_algorithm: nil,
          filtering_algorithm: nil,
          lookahead_algorithm: nil,
          max_solutions: 1
        )
        .and_return algorithm

      expect(csp.solve).to be_empty
      expect(algorithm).to have_received(:backtracking).with({})
    end
  end

  describe '#add_variable' do
    it 'adds a variable to the problem' do
      variable = double('Variable', empty?: false)
      domains = double('Domains', empty?: false)
      variables = [variable]

      csp = described_class.new
        .add_variable(variable, domains: domains)

      expect(csp).to have_attributes(
        class: described_class,
        variables: variables,
        domains: { variable => domains },
        constraints: { variable => [] },
        max_solutions: 1
      )
    end

    context 'when multiple variables' do
      it 'add all the variables' do
        variable = double('Variable', empty?: false)
        variable2 = double('Variable', empty?: false)
        domains = double('Domains', empty?: false)
        variables = [variable, variable2]

        csp = described_class.new
          .add_variable(variable, domains: domains)
          .add_variable(variable2, domains: domains)

        expect(csp).to have_attributes(
          class: described_class,
          variables: variables,
          domains: { variable => domains, variable2 => domains },
          constraints: { variable => [], variable2 => [] },
          max_solutions: 1
        )
      end
    end

    describe '#add_variables' do
      it 'should call #add_variable n times' do
        variable = double('Variable', empty?: false)
        variable2 = double('Variable', empty?: false)
        domains = double('Domains', empty?: false)
        variables = [variable, variable2]

        csp = described_class.new
        allow(csp).to receive(:add_variable).and_call_original
        csp.add_variables(variables, domains: domains)

        variables.each do |variable| # rubocop:disable Lint/ShadowingOuterLocalVariable
          expect(csp).to have_received(:add_variable).with(variable, domains: domains).once
        end
      end

      it 'add multiple variables with same domain' do
        variable = double('Variable', empty?: false)
        variable2 = double('Variable', empty?: false)
        domains = double('Domains', empty?: false)
        variables = [variable, variable2]

        csp = described_class.new
          .add_variables(variables, domains: domains)

        expect(csp).to have_attributes(
          class: described_class,
          variables: variables,
          domains: { variable => domains, variable2 => domains },
          constraints: { variable => [], variable2 => [] },
          max_solutions: 1
        )
      end
    end

    context 'raises an error' do
      it 'because variable was empty' do
        variable = double('Variable', empty?: true)
        domains = double('Domains', empty?: false)

        csp = described_class.new
        expect { csp.add_variable(variable, domains: domains) }
          .to raise_error described_class::VariableShouldNotBeEmpty,
                          'Variable was empty in the function parameter'
      end

      it 'because domains was empty' do
        variable = double('Variable', empty?: false)
        domains = double('Domains', empty?: true)

        csp = described_class.new
        expect { csp.add_variable(variable, domains: domains) }
          .to raise_error described_class::DomainsShouldNotBeEmpty,
                          'Domains was empty in the function parameter'
      end

      it 'because variable is already seted' do
        variable = double('Variable', empty?: false)
        domains = double('Domains', empty?: false)

        csp = described_class.new
          .add_variable(variable, domains: domains)

        expect { csp.add_variable(variable, domains: domains) }
          .to raise_error described_class::VariableAlreadySeted,
                          'Variable #[Double "Variable"] has already been seted'
      end
    end
  end

  describe '#all_different' do
    it 'adds the default constraint' do
      variable = double('Variable', empty?: false)
      variable2 = double('Variable', empty?: false)
      variables = [variable, variable2]
      domains = double('Domains', empty?: false)

      csp = described_class.new
        .add_variables(variables, domains: domains)
        .all_different

      expect(csp.constraints[variable].first).to be_a(CSP::Constraints::AllDifferentConstraint)
      expect(csp.constraints[variable2].first).to be_a(CSP::Constraints::AllDifferentConstraint)
      expect(csp.constraints[variable].first.variables).to match_array(variables)
    end
  end

  describe '#unique' do
    it 'adds the default constraint' do
      variable = double('Variable', empty?: false)
      variable2 = double('Variable', empty?: false)
      variable3 = double('Variable', empty?: false)
      variables = [variable, variable2, variable3]
      domains = double('Domains', empty?: false)

      csp = described_class.new
        .add_variables(variables, domains: domains)
        .unique([variable, variable2])

      expect(csp.constraints[variable].first).to be_a(CSP::Constraints::UniqueConstraint)
      expect(csp.constraints[variable2].first).to be_a(CSP::Constraints::UniqueConstraint)
      expect(csp.constraints[variable3]).to eq []
      expect(csp.constraints[variable].first.variables).to match_array([variable, variable2])
    end
  end

  describe '#add_constraint' do
    context 'when passing a constraint instance to the method' do
      it 'adds a constraint to variable' do
        variable = double('Variable', empty?: false)
        domains = double('Domains', empty?: false)
        constraint = double('Constraint', variables: [variable])

        csp = described_class.new
          .add_variable(variable, domains: domains)
          .add_constraint(constraint)

        expect(csp.constraints).to include(variable => [constraint])
      end

      context 'when multiple variables' do
        it 'maps the constraint for each one' do
          variable = double('Variable', empty?: false)
          variable2 = double('Variable', empty?: false)
          variables = [variable, variable2]
          domains = double('Domains', empty?: false)
          constraint = double('Constraint', variables: variables)

          csp = described_class.new
            .add_variable(variable, domains: domains)
            .add_variable(variable2, domains: domains)
            .add_constraint(constraint)

          expect(csp.constraints).to include(variable => [constraint])
          expect(csp.constraints).to include(variable2 => [constraint])
        end
      end
    end

    context 'when passing a block and variables to the method' do
      it 'adds a constraint to variable' do
        variable = double('Variable', empty?: false)
        domains = double('Domains', empty?: false)
        variables = [variable]

        csp = described_class.new
          .add_variable(variable, domains: domains)

        csp.add_constraint(variables: variables) { |var| var == 0 }

        expect(csp.constraints[variable].first).to be_a(CSP::Constraints::CustomConstraint)
      end

      context 'when multiple variables' do
        it 'adds a constraint for each variable' do
          variable = double('Variable', empty?: false)
          variable2 = double('Variable', empty?: false)
          domains = double('Domains', empty?: false)
          variables = [variable, variable2]

          csp = described_class.new
            .add_variables(variables, domains: domains)

          csp.add_constraint(variables: variables) { |var, var3| var == var3 }

          expect(csp.constraints[variable].first).to be_a(CSP::Constraints::CustomConstraint)
          expect(csp.constraints[variable2].first).to be_a(CSP::Constraints::CustomConstraint)
        end
      end
    end

    context 'when parameter validates fail' do
      context 'variables was passed but block not' do
        it 'raises an error' do
          variable = double('Variable', empty?: false)
          domains = double('Domains', empty?: false)
          variables = [variable]
          csp = described_class.new
            .add_variables(variables, domains: domains)

          expect { csp.add_constraint(variables: variables) }
            .to raise_error ArgumentError, 'Either constraint or block must be provided'
        end
      end
      context 'block was passed but variable not' do
        it 'raises an error' do
          variable = double('Variable', empty?: false)
          domains = double('Domains', empty?: false)
          variables = [variable]

          csp = described_class.new
            .add_variables(variables, domains: domains)

          expect { csp.add_constraint { |var, var3| var == var3 } }
            .to raise_error ArgumentError, 'Variables must be provided when using a block'
        end
      end
      context 'constraint and block was passed' do
        it 'raises an error' do
          variable = double('Variable', empty?: false)
          domains = double('Domains', empty?: false)
          variables = [variable]
          constraint = double('Constraint', variables: variables)

          csp = described_class.new
            .add_variables(variables, domains: domains)

          expect { csp.add_constraint(constraint) { |var, var3| var == var3 } }
            .to raise_error ArgumentError, 'Both constraint and block cannot be provided at the same time'
        end
      end
      context 'block arity is greather than variables quantity' do
        it 'raises an error' do
          variable = double('Variable', empty?: false)
          domains = double('Domains', empty?: false)
          variables = [variable]

          csp = described_class.new
            .add_variables(variables, domains: domains)

          expect { csp.add_constraint(variables: variables) { |var, var3| var == var3 } }
            .to raise_error ArgumentError, 'Block should not have more arity than the quantity of variables'
        end
      end
    end

    context 'when constraint has a variable that does not exists in CSP' do
      it 'raises an error' do
        variable = double('Variable', empty?: false)
        diff_variable = double('Variable', empty?: false)
        domains = double('Domains', empty?: false)
        constraint = double('Constraint', variables: [variable])

        csp = described_class.new
          .add_variable(diff_variable, domains: domains)

        expect { csp.add_constraint(constraint) }
          .to raise_error described_class::InvalidConstraintVariable,
                          "Constraint's variable doesn't exists in CSP"
      end
    end
  end

  describe '#add_ordering' do
    it 'sets the ordering algorithm for CSP' do
      ordering_algorithm = instance_double(CSP::Algorithms::Ordering::NoOrder)
      csp = described_class.new
        .add_ordering(ordering_algorithm)

      expect(csp).to have_attributes(ordering_algorithm: ordering_algorithm)
    end
  end

  describe '#add_filtering' do
    it 'sets the filtering algorithm for CSP' do
      filtering_algorithm = instance_double(CSP::Algorithms::Filtering::NoFilter)
      csp = described_class.new
        .add_filtering(filtering_algorithm)

      expect(csp).to have_attributes(filtering_algorithm: filtering_algorithm)
    end
  end

  describe '#add_lookahead' do
    it 'sets the lookahead algorithm for CSP' do
      lookahead_algorithm = instance_double(CSP::Algorithms::Lookahead::Ac3)
      csp = described_class.new
        .add_lookahead(lookahead_algorithm)

      expect(csp).to have_attributes(lookahead_algorithm: lookahead_algorithm)
    end
  end
end
