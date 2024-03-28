# frozen_string_literal: true

module CSP
  module Problems
    class EventScheduling
      def call
        number_of_events = 3
        number_of_time_slots = 4

        variables = number_of_events.times.to_a
        domains = variables.reduce({}) do |domains, variable|
          domains.merge(variable => number_of_time_slots.times.to_a)
        end

        csp = CSP::Problem.new(variables:, domains:)

        variables.combination(2).each do |events|
          add_constraint(csp, *events)
        end

        solution = csp.solve
        message = solution || 'No solution found'

        puts(message)
      end

      def add_constraint(csp, event1, event2)
        csp.add_constraint(OnlyOneConstraint.new(event1, event2))
      end
    end

    class OnlyOneConstraint < ::CSP::Constraint
      attr_reader :event1, :event2

      def initialize(event1, event2)
        super([event1, event2])

        @event1 = event1
        @event2 = event2
      end

      def satisfies?(assignment)
        return true if variables.any? { |variable| !assignment.key?(variable) }

        assignment[event1] != assignment[event2]
      end
    end
  end
end

