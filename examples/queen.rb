# frozen_string_literal: true

require_relative '../lib/csp-resolver'

module CSP
  module Examples
    class Queen
      def call(queens_number = 8)
        variables = queens_number.times.to_a

        csp = CSP::Problem.new
          .add_variables(variables, domains: variables)
          .add_constraint(QueensConstraint.new(variables))
        solution = csp.solve

        solution || 'No solution found'
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
end
