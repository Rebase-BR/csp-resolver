# frozen_string_literal: true

require_relative '../constraint'
require_relative '../problem'

module CSP
  module Problems
    # Three sculptures (A, B, C) are to be exhibited in rooms 1,2 of an art gallery
    #
    # The exhibition must satisfy the following conditions:
    # 1. Sculptures A and B cannot be in the same room
    # 2. Sculptures B and C must be in the same room
    # 3. Room 2 can only hold one sculpture
    class Sculpture
      def call
        variables = %w[A B C]

        domains = variables.each_with_object({}) do |variable, domains|
          domains[variable] = [1, 2]
        end

        csp = CSP::Problem.new(variables:, domains:)
        csp.add_constraint(CannotBeInSameRoom.new(%w[A B]))
        csp.add_constraint(MustBeInSameRoomConstraint.new(%w[B C]))
        csp.add_constraint(RoomLimitToOneConstraint.new(room: 2, variables:))
        solution = csp.solve

        message = solution || 'No solution found'

        puts message
      end

      class CannotBeInSameRoom < ::CSP::Constraint
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
