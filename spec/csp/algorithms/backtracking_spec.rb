# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSP::Algorithms::Backtracking do
  describe '#backtracking' do
    context 'when domain assignment is consistent' do
      it 'pass the new assignment with domain to backtracking' do
        variable = double('Variable')
        variable2 = double('Variable')
        variables = [variable, variable2]
        domains = { variable => [1], variable2 => [10] }

        constraint = double('constraint', satisfies?: true)
        constraint2 = double('constraint', satisfies?: false)
        constraints = { variable => [constraint], variable2 => [constraint2] }

        problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

        algorithm = described_class.new(problem: problem)

        allow(algorithm).to receive(:backtracking_recursion).and_call_original

        expect(algorithm.backtracking).to be_empty
        expect(algorithm).to have_received(:backtracking_recursion).with({}, domains)
        expect(algorithm).to have_received(:backtracking_recursion).with({ variable => 1 }, domains)
      end

      context 'when backtracking returns a solution' do
        it 'returns the solution to the call stack' do
          variable = double('Variable')
          variable2 = double('Variable')
          variables = [variable, variable2]

          domains = { variable => [1], variable2 => [10] }

          constraint = double('constraint', satisfies?: true)
          constraint2 = double('constraint', satisfies?: true)
          constraints = { variable => [constraint], variable2 => [constraint2] }

          problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

          algorithm = described_class.new(problem: problem)

          allow(algorithm).to receive(:backtracking_recursion).and_call_original

          expect(algorithm.backtracking).to eq [variable => 1, variable2 => 10]
          expect(algorithm).to have_received(:backtracking_recursion).with({}, domains)
          expect(algorithm).to have_received(:backtracking_recursion).with({ variable => 1 }, domains)
          expect(algorithm).to have_received(:backtracking_recursion).with(
            {
              variable => 1,
              variable2 => 10
            }, domains
          )
        end
      end

      context 'when backtracking returns nil' do
        context 'and variable has more domains to verify' do
          it 'attemps the next value' do
            variable = double('Variable')
            variable2 = double('Variable')
            variables = [variable, variable2]

            domains = { variable => [1, 2], variable2 => [10] }

            constraint = double('constraint', satisfies?: true)
            constraint2 = double('constraint')
            constraints = { variable => [constraint], variable2 => [constraint2] }

            problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

            algorithm = described_class.new(problem: problem)

            allow(constraint2).to receive(:satisfies?).and_return(false, true)
            allow(algorithm).to receive(:backtracking_recursion).and_call_original

            expect(algorithm.backtracking).to eq [variable => 2, variable2 => 10]
            expect(algorithm).to have_received(:backtracking_recursion).with({}, domains)
            expect(algorithm).to have_received(:backtracking_recursion).with({ variable => 1 }, domains)
            expect(algorithm).to have_received(:backtracking_recursion).with({ variable => 2 }, domains)
            expect(algorithm).to have_received(:backtracking_recursion).with({
              variable => 2,
              variable2 => 10
            }, domains)
          end
        end

        context 'and variable has no more domains to verify' do
          it 'returns nil' do
            variable = double('Variable')
            variable2 = double('Variable')
            variables = [variable, variable2]

            domains = { variable => [1, 2], variable2 => [10] }

            constraint = double('constraint', satisfies?: true)
            constraint2 = double('constraint', satisfies?: false)
            constraints = { variable => [constraint], variable2 => [constraint2] }

            problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

            algorithm = described_class.new(problem: problem)

            allow(algorithm).to receive(:backtracking_recursion).and_call_original

            expect(algorithm.backtracking).to be_empty
            expect(algorithm).to have_received(:backtracking_recursion).with({}, domains)
            expect(algorithm).to have_received(:backtracking_recursion).with({ variable => 1 }, domains)
          end
        end
      end
    end

    context 'when no domain assignment is consistent' do
      it 'returns nil' do
        variable = double('Variable')
        variables = [variable]

        domains = { variable => [1, 2, 3, 4] }

        constraint = double('constraint', satisfies?: false)
        constraints = { variable => [constraint] }

        problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

        algorithm = described_class.new(problem: problem)

        expect(algorithm.backtracking).to be_empty
      end
    end

    context 'when all variables are assigned' do
      it 'returns the assignments' do
        variable = double('Variable')
        domain = double('Domains')
        problem = double('Problem', variables: [variable], domains: [domain])

        assignment = { variable => 1 }

        algorithm = described_class.new(problem: problem)

        expect(algorithm.backtracking(assignment)).to eq [assignment]
      end
    end

    context 'when using different ordering algorithm' do
      it 'uses the new algorithm to order the unassigned variables' do
        variable = double('Variable')
        variable2 = double('Variable')
        variables = [variable, variable2]

        domains = { variable => [1, 2], variable2 => [3, 4] }

        constraint = double('constraint', satisfies?: true)
        constraints = { variable => [constraint], variable2 => [constraint] }

        ordering_algorithm = double('OrderingAlgorithm')

        problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

        algorithm = described_class.new(problem: problem, ordering_algorithm: ordering_algorithm)

        allow(algorithm).to receive(:backtracking_recursion).and_call_original
        allow(algorithm).to receive(:domains_for).and_call_original
        allow(ordering_algorithm).to receive(:call), &:reverse

        expect(algorithm.backtracking).to eq([{ variable => 1, variable2 => 3 }])
        expect(algorithm).to have_received(:backtracking_recursion).with({}, domains)
        expect(algorithm).to have_received(:backtracking_recursion).with({ variable2 => 3 }, domains)
        expect(algorithm).to have_received(:domains_for).with(variable2, {}, domains)
        expect(algorithm).to have_received(:domains_for).with(variable, { variable2 => 3 }, domains)
      end
    end

    context 'when using different filtering algorithm' do
      it 'uses the new algorithm to filter the domains' do
        variable = double('Variable')
        variables = [variable]
        domains = { variable => [1, 2, 3, 4, 5] }
        constraint = double('constraint', satisfies?: false)
        constraints = { variable => [constraint] }
        filtering_algorithm = double('FilteringAlgorithm')

        problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

        algorithm = described_class.new(problem: problem, filtering_algorithm: filtering_algorithm)

        allow(algorithm).to receive(:backtracking).and_call_original
        allow(algorithm).to receive(:consistent?).and_call_original
        allow(filtering_algorithm).to receive(:call).and_return [2, 4]

        expect(algorithm.backtracking).to be_empty
        expect(algorithm).to have_received(:backtracking).with(no_args)
        expect(algorithm).to have_received(:consistent?).twice
        expect(algorithm).to have_received(:consistent?).with(variable, { variable => 2 })
        expect(algorithm).to have_received(:consistent?).with(variable, { variable => 4 })
        expect(filtering_algorithm).to have_received(:call).with(
          values: [1, 2, 3, 4, 5],
          assignment_values: []
        )
      end
    end

    context 'when using different lookahead algorithm' do
      context 'when domain and lookahead are consistent' do
        it 'recurses with a pruned domain' do
          variable1 = double('Variable')
          variable2 = double('Variable')
          variables = [variable1, variable2]

          domains = { variable1 => [1, 2], variable2 => [1, 2] }

          constraint = double('constraint', variables: variables, binary?: true, unary?: false)
          constraints = { variable1 => [constraint], variable2 => [constraint] }

          problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

          allow(constraint).to receive(:satisfies?).and_return(true, false, false, true)

          algorithm = described_class.new(
            problem: problem,
            lookahead_algorithm: CSP::Algorithms::Lookahead::Ac3.new(problem)
          )

          expect(algorithm.backtracking).to eq([{ variable1 => 2, variable2 => 1 }])
        end
      end

      context 'when domain is consistent but lookahead fails' do
        it 'does not consider value assignment' do
          variable1 = double('Variable')
          variable2 = double('Variable')
          variables = [variable1, variable2]

          domains = { variable1 => [1, 2], variable2 => [1, 2] }

          constraint = double('constraint', variables: variables, binary?: true, unary?: false)
          constraints = { variable1 => [constraint], variable2 => [constraint] }

          problem = double('Problem', variables: variables, domains: domains, constraints: constraints)

          allow(constraint).to receive(:satisfies?).and_return(true, false)

          algorithm = described_class.new(
            problem: problem,
            lookahead_algorithm: CSP::Algorithms::Lookahead::Ac3.new(problem)
          )

          expect(algorithm.backtracking).to be_empty
        end
      end
    end
  end

  describe '#consistent?' do
    context 'variable satisfies all its constraints' do
      it 'returns true' do
        variable = double('Variable')
        constraint = double('Constraint', satisfies?: true)
        assignment = { variable => 1 }

        problem = double(
          'Problem',
          variables: [variable],
          domains: spy,
          constraints: { variable => [constraint] }
        )

        consistent = described_class
          .new(problem: problem)
          .consistent?(variable, assignment)

        expect(consistent).to eq true
      end
    end

    context 'when at least one constraint is not satisfied' do
      it 'returns false' do
        variable = double('Variable')
        constraint = double('Constraint', satisfies?: true)
        constraint2 = double('Constaint', satisfies?: false)
        assignment = { variable => 1 }

        problem = double(
          'Problem',
          variables: [variable],
          domains: spy,
          constraints: { variable => [constraint, constraint2] }
        )

        consistent = described_class
          .new(problem: problem)
          .consistent?(variable, assignment)

        expect(consistent).to eq false
      end
    end
  end
end
