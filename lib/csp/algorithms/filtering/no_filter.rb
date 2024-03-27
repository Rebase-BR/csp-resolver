# frozen_string_literal: true

module CSP
  module Algorithms
    module Filtering
      class NoFilter
        attr_reader :problem

        def self.for(problem:, dependency: nil)
          new(problem)
        end

        def initialize(problem)
          @problem = problem
        end

        # rubocop:disable Lint/UnusedMethodArgument
        def call(values:, assignment_values: [])
          values
        end
        # rubocop:enable Lint/UnusedMethodArgument
      end
    end
  end
end
