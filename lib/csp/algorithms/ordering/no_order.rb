# frozen_string_literal: true

module CSP
  module Algorithms
    module Ordering
      class NoOrder
        attr_reader :problem

        def self.for(problem:, dependency: nil)
          new(problem)
        end

        def initialize(problem)
          @problem = problem
        end

        def call(variables)
          variables
        end
      end
    end
  end
end
