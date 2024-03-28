# frozen_string_literal: true
#
require_relative '../../constraint'
require_relative '../../problem'

module CSP
  module Problems
    class Queen
      def call(n = 8)
        columns = n.times.to_a

        rows = columns.each_with_object({}) do |column, rows|
          rows[column] = n.times.to_a
        end

        csp = CSP::Problem.new(variables: columns, domains: rows)
        csp.add_constraint(QueensConstraint.new(columns))
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
