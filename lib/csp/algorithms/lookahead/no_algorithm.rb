# frozen_string_literal: true

module CSP
  module Algorithms
    module Lookahead
      class NoAlgorithm
        attr_reader :problem

        def initialize(problem)
          @problem = problem
        end

        def call(variables:, assignment:, domains:)
          domains
        end
      end
    end
  end
end
