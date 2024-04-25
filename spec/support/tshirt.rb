# frozen_string_literal: true

require_relative '../../lib/csp/constraint'

class Tshirt
  def people
    %w[A B C]
  end

  def colors
    %w[red green blue]
  end

  class UniqueConstraint < ::CSP::Constraint
    attr_reader :person_a, :person_b

    def initialize(person_a, person_b)
      super([person_a, person_b])
      @person_a = person_a
      @person_b = person_b
    end

    def satisfies?(assignment = {})
      return true if skip?(assignment)

      shirt_color_a = assignment[person_a]
      shirt_color_b = assignment[person_b]

      shirt_color_a != shirt_color_b
    end

    def skip?(assignment)
      !variables.all? { |variable| assignment.key?(variable) }
    end
  end

  class ColorConstraint < ::CSP::Constraint
    attr_reader :person, :color

    def initialize(person:, color:)
      super([person])

      @person = person
      @color = color
    end

    def satisfies?(assignment = {})
      return true if skip?(assignment)

      picked_color = assignment[person]

      picked_color != color
    end

    def skip?(assignment)
      !variables.all? { |variable| assignment.key?(variable) }
    end
  end
end
