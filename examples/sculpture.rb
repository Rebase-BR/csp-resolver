# frozen_string_literal: true

require_relative '../lib/csp-resolver'

module CSP
  module Examples
    # Three sculptures (A, B, C) are to be exhibited in rooms 1,2 of an art gallery
    #
    # The exhibition must satisfy the following conditions:
    # 1. Sculptures A and B cannot be in the same room
    # 2. Sculptures B and C must be in the same room
    # 3. Room 2 can only hold one sculpture
    class Sculpture
      def call
        variables = %w[A B C]

        csp = CSP::Problem.new
          .add_variable('A', domains: [1, 2])
          .add_variable('B', domains: [1, 2])
          .add_variable('C', domains: [1, 2])
          .unique(%w[A B])
          .add_constraint(variables: %w[B C]) { |b, c| b == c }
          .add_constraint(RoomLimitToOneConstraint.new(room: 2, variables: variables))
        solution = csp.solve

        solution || 'No solution found'
      end

      class CannotBeInSameRoomConstraint < ::CSP::Constraint
        def satisfies?(assignment)
          values = assignment.values_at(*variables)

          return true if values.any?(&:nil?)

          values == values.uniq
        end
      end

      class MustBeInSameRoomConstraint < ::CSP::Constraint
        def satisfies?(assignment)
          values = assignment.values_at(*variables)

          return true if values.any?(&:nil?)

          values.uniq.size == 1
        end
      end

      class RoomLimitToOneConstraint < ::CSP::Constraint
        attr_reader :room

        def initialize(room:, variables:)
          super(variables)
          @room = room
        end

        def satisfies?(assignment)
          values = assignment.values_at(*variables)

          values.count(room) <= 1
        end
      end
    end
  end
end
