# frozen_string_literal: true

require_relative 'filtering/no_filter'
require_relative 'ordering/no_order'
require 'forwardable'

module CSP
  module Algorithms
    class Backtracking
      extend Forwardable

      ORDERING_ALGORITHM = Ordering::NoOrder
      FILTERING_ALGORITHM = Filtering::NoFilter

      attr_reader :problem, :solutions, :max_solutions,
                  :ordering_algorithm, :filtering_algorithm

      def_delegators :problem, :variables, :domains, :constraints

      def initialize(problem:, ordering_algorithm: nil, filtering_algorithm: nil, max_solutions: 1)
        @problem = problem
        @ordering_algorithm = ordering_algorithm || ORDERING_ALGORITHM.new(problem)
        @filtering_algorithm = filtering_algorithm || FILTERING_ALGORITHM.new(problem)
        @max_solutions = max_solutions
        @solutions = []
      end

      def backtracking(assignment = {})
        return solutions if max_solutions?
        return add_solution(assignment) if complete?(assignment)

        unassigned = next_unassigned_variable(assignment)

        domains_for(unassigned, assignment).each do |value|
          local_assignment = assignment.clone
          local_assignment[unassigned] = value

          next unless consistent?(unassigned, local_assignment)

          backtracking(local_assignment)

          return solutions if max_solutions?
        end

        []
      end

      def consistent?(variable, assignment)
        constraints[variable].all? do |constraint|
          constraint.satisfies?(assignment)
        end
      end

      private

      def add_solution(assignment)
        solutions << assignment
      end

      def max_solutions?
        solutions.size >= max_solutions
      end

      def complete?(assignment)
        assignment.size == variables.size
      end

      def next_unassigned_variable(assignment)
        unassigned_variables(assignment).first
      end

      def unassigned_variables(assignment)
        variables
          .reject { |variable| assignment.key?(variable) }
          .yield_self { |v| ordering_algorithm.call(v) }
      end

      def domains_for(unassigned, assignment)
        filtering_algorithm.call(
          values: domains[unassigned],
          assignment_values: assignment.values.flatten
        )
      end
    end
  end
end
