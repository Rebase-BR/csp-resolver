# frozen_string_literal: true

require_relative '../../../support/tshirt'

RSpec.describe CSP::Algorithms::Lookahead::Ac3 do
  describe '#call' do
    it 'returns new domains that satisfies the unary constraints' do
      color_constraint = Tshirt::ColorConstraint

      problem = Tshirt.new
      variables = problem.people # A B C
      domain_values = problem.colors # red green blue
      domains = variables.product([domain_values]).to_h #  { A => [red, green, blue] }

      constraint_a_not_blue = color_constraint.new(person: 'A', color: 'blue')
      constraint_b_not_blue = color_constraint.new(person: 'B', color: 'blue')
      constraint_b_not_red = color_constraint.new(person: 'B', color: 'red')
      constraint_c_not_red = color_constraint.new(person: 'C', color: 'red')

      problem = ::CSP::Problem.new
        .add_variables(variables, domains: domains)
        .add_constraint(constraint_a_not_blue)
        .add_constraint(constraint_b_not_blue)
        .add_constraint(constraint_b_not_red)
        .add_constraint(constraint_c_not_red)

      algorithm = described_class.new(problem)

      new_domains = algorithm.call(
        variables: variables,
        assignment: {},
        domains: domains
      )

      expect(new_domains).to eq(
        {
          'A' => %w[red green],
          'B' => %w[green],
          'C' => %w[green blue]
        }
      )
    end

    context 'when receives an assigment' do
      it 'returns new domains that satisfies the unary constraints' do
        color_constraint = Tshirt::ColorConstraint

        problem = Tshirt.new
        variables = problem.people # A B C
        domain_values = problem.colors # red green blue
        domains = variables.product([domain_values]).to_h #  { A => [red, green, blue] }

        constraint_a_not_blue = color_constraint.new(person: 'A', color: 'blue')
        constraint_b_not_blue = color_constraint.new(person: 'B', color: 'blue')
        constraint_b_not_red = color_constraint.new(person: 'B', color: 'red')
        constraint_c_not_red = color_constraint.new(person: 'C', color: 'red')

        problem = ::CSP::Problem.new
          .add_variables(variables, domains: domains)
          .add_constraint(constraint_a_not_blue)
          .add_constraint(constraint_b_not_blue)
          .add_constraint(constraint_b_not_red)
          .add_constraint(constraint_c_not_red)

        algorithm = described_class.new(problem)

        new_domains = algorithm.call(
          variables: variables,
          assignment: { 'A' => 'red' },
          domains: domains
        )

        expect(new_domains).to eq(
          {
            'A' => %w[red],
            'B' => %w[green],
            'C' => %w[green blue]
          }
        )
      end
    end

    context 'when it has binary constraints' do
      it 'returns new domains that satisfies the binary constraints' do
        color_constraint = Tshirt::ColorConstraint
        unique_constraint = Tshirt::UniqueConstraint

        problem = Tshirt.new
        variables = problem.people # A B C
        domain_values = problem.colors # red green blue
        domains = variables.product([domain_values]).to_h #  { A => [red, green, blue] }

        constraint_a_not_blue = color_constraint.new(person: 'A', color: 'blue')
        constraint_b_not_blue = color_constraint.new(person: 'B', color: 'blue')
        constraint_b_not_red = color_constraint.new(person: 'B', color: 'red')
        constraint_c_not_red = color_constraint.new(person: 'C', color: 'red')
        constraint_b_diff_a = unique_constraint.new('B', 'A')
        constraint_b_diff_c = unique_constraint.new('B', 'C')
        constraint_a_diff_c = unique_constraint.new('A', 'C')

        problem = ::CSP::Problem.new
          .add_variables(variables, domains: domains)
          .add_constraint(constraint_a_not_blue)
          .add_constraint(constraint_b_not_blue)
          .add_constraint(constraint_b_not_red)
          .add_constraint(constraint_c_not_red)
          .add_constraint(constraint_b_diff_a)
          .add_constraint(constraint_b_diff_c)
          .add_constraint(constraint_a_diff_c)

        algorithm = described_class.new(problem)

        new_domains = algorithm.call(
          variables: variables,
          assignment: { 'A' => 'red' },
          domains: domains
        )

        expect(new_domains).to eq(
          {
            'A' => %w[red],
            'B' => %w[green],
            'C' => %w[blue]
          }
        )
      end
    end

    context 'when it is inconsistent' do
      it 'returns nil' do
        color_constraint = Tshirt::ColorConstraint
        unique_constraint = Tshirt::UniqueConstraint

        problem = Tshirt.new
        variables = problem.people # A B C
        domain_values = problem.colors # red green blue
        domains = variables.product([domain_values]).to_h #  { A => [red, green, blue] }

        constraint_a_not_blue = color_constraint.new(person: 'A', color: 'blue')
        constraint_b_not_blue = color_constraint.new(person: 'B', color: 'blue')
        constraint_b_not_red = color_constraint.new(person: 'B', color: 'red')
        constraint_c_not_red = color_constraint.new(person: 'C', color: 'red')
        constraint_b_diff_a = unique_constraint.new('B', 'A')
        constraint_b_diff_c = unique_constraint.new('B', 'C')
        constraint_a_diff_c = unique_constraint.new('A', 'C')

        problem = ::CSP::Problem.new
          .add_variables(variables, domains: domains)
          .add_constraint(constraint_a_not_blue)
          .add_constraint(constraint_b_not_blue)
          .add_constraint(constraint_b_not_red)
          .add_constraint(constraint_c_not_red)
          .add_constraint(constraint_b_diff_a)
          .add_constraint(constraint_b_diff_c)
          .add_constraint(constraint_a_diff_c)

        algorithm = described_class.new(problem)

        new_domains = algorithm.call(
          variables: variables,
          assignment: { 'A' => 'green' },
          domains: domains
        )

        expect(new_domains).to be_nil
      end
    end
  end
end
