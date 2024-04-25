# frozen_string_literal: true

module CSP
  class Constraint
    attr_reader :variables

    def initialize(variables = [])
      @variables = variables
    end

    def satisfies?(_assignment = {})
      raise StandardError, 'Not Implemented. Should return a boolean'
    end

    def unary?
      arity == 1
    end

    def binary?
      arity == 2
    end

    def arity
      @arity ||= variables.size
    end
  end
end
