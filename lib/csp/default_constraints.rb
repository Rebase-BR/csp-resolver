# frozen_string_literal: true

require_relative 'constraint'

module CSP
  module DefaultConstraints
    class AllDifferentConstraint < CSP::Constraint
      def satisfies?(assignment)
        assignment.values == assignment.values.uniq
      end
    end

    def all_different(variables)
      add_constraint(AllDifferentConstraint.new(variables))

      self
    end
  end
end

# def satisfies?(assignment)
#   assignment.values == assignment.values.uniq
# end
