# frozen_string_literal: true

require_relative '../../constraint'
require_relative '../../problem'

module CSP
  module Problems
    class MapColoring
      def call
        domains = %w[red blue green]

        csp = CSP::Problem.new
          .add_variable('Western Australia', domains:)
          .add_variable('Northern Territory', domains:)
          .add_variable('South Australia', domains:)
          .add_variable('Queensland', domains:)
          .add_variable('New South Wales', domains:)
          .add_variable('Victoria', domains:)
          .add_variable('Tasmania', domains:)

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
        message = solution || 'No solution found'

        puts(message)
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
