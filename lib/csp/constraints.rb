# frozen_string_literal: true

require_relative 'constraint'

module CSP
  module Constraints
    class AllDifferentConstraint < CSP::Constraint
      def satisfies?(assignment)
        assignment.values == assignment.values.uniq
      end
    end

    class UniqueConstraint < CSP::Constraint
      def satisfies?(assignment)
        values = assignment.values_at(*variables)

        return true if values.any?(&:nil?)

        values == values.uniq
      end
    end

    class CustomConstraint < CSP::Constraint
      attr_reader :block

      def initialize(variables, block)
        super(variables)
        @block = block
      end

      def satisfies?(assignment)
        values = assignment.values_at(*variables)
        return true if values.any?(&:nil?)

        block.call(values)
      end
    end

    def all_different
      add_constraint(AllDifferentConstraint.new(variables))

      self
    end

    def unique(variables)
      add_constraint(UniqueConstraint.new(variables))

      self
    end
  end
end
