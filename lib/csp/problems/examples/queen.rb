# frozen_string_literal: true

require_relative '../../constraint'
require_relative '../../problem'

module CSP
  module Problems
    class Queen
      def call(n = 8)
        variables = n.times.to_a

        csp = CSP::Problem.new
        n.times do |i|
          csp.add_variable(i, domains: variables)
        end
        csp.add_constraint(QueensConstraint.new(variables))
        solution = csp.solve

        message = solution || 'No solution found'

        puts message
      end
    end

    class QueensConstraint < ::CSP::Constraint
      attr_reader :columns

      def initialize(columns)
        super(columns)

        @columns = columns
      end

      def satisfies?(assignment)
        assignment.each do |(queen_col1, queen_row1)|
          (queen_col1 + 1..columns.size).each do |queen_col2|
            next unless assignment.key?(queen_col2)

            queen_row2 = assignment[queen_col2]

            return false if queen_row1 == queen_row2
            return false if (queen_row1 - queen_row2).abs == (queen_col1 - queen_col2).abs
          end
        end

        true
      end
    end
  end
end
