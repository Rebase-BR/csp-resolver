# frozen_string_literal: true

require_relative 'constraint'

module CSP
  module DefaultConstraints
    class AllDifferentConstraint < CSP::Constraint
      def satisfies?(assignment)
        return true if assignment.values.any?(&:nil?)

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

    def all_different(variables)
      add_constraint(AllDifferentConstraint.new(variables))

      self
    end

    def unique(variables)
      add_constraint(UniqueConstraint.new(variables))

      self
    end
  end
end
