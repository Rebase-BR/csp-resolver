# frozen_string_literal: true

require_relative '../lib/csp/constraint'
require_relative '../lib/csp/problem'

module CSP
  module Examples
    class MapColoring
      def call # rubocop:disable Metrics/MethodLength
        variables = [
          'Western Australia',
          'Northern Territory',
          'South Australia',
          'Queensland',
          'New South Wales',
          'Victoria',
          'Tasmania'
        ]

        domains = %w[red blue green]

        csp = CSP::Problem.new
          .add_variables(variables, domains: domains)

        add_constraint(csp, 'Western Australia', 'Northern Territory')
        add_constraint(csp, 'Western Australia', 'South Australia')
        add_constraint(csp, 'South Australia', 'Northern Territory')
        add_constraint(csp, 'Queensland', 'Northern Territory')
        add_constraint(csp, 'Queensland', 'South Australia')
        add_constraint(csp, 'Queensland', 'New South Wales')
        add_constraint(csp, 'New South Wales', 'South Australia')
        add_constraint(csp, 'Victoria', 'South Australia')
        add_constraint(csp, 'Victoria', 'New South Wales')
        add_constraint(csp, 'Victoria', 'Tasmania')

        solution = csp.solve
        solution || 'No solution found'
      end

      def add_constraint(csp, place1, place2)
        csp.add_constraint(MapColoringConstraint.new(place1, place2))
      end
    end

    class MapColoringConstraint < ::CSP::Constraint
      attr_reader :place1, :place2

      def initialize(place1, place2)
        super([place1, place2])

        @place1 = place1
        @place2 = place2
      end

      def satisfies?(assignment)
        # If any of them is not assigned then there's no conflict
        return true if variables.any? { |variable| !assignment.key?(variable) }

        assignment[place1] != assignment[place2]
      end
    end
  end
end
