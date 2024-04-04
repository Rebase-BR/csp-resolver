# frozen_string_literal: true

module CSP
  module Algorithms
    module Filtering
      class NoFilter
        attr_reader :problem

        def self.for(problem:, dependency: nil) # rubocop:disable Lint/UnusedMethodArgument
          new(problem)
        end

        def initialize(problem)
          @problem = problem
        end

        def call(values:, assignment_values: []) # rubocop:disable Lint/UnusedMethodArgument
          values
        end
      end
    end
  end
end
