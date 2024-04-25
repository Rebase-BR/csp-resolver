# frozen_string_literal: true

require_relative 'filtering/no_filter'
require_relative 'ordering/no_order'
require_relative 'lookahead/no_algorithm'
require 'forwardable'

module CSP
  module Algorithms
    class Backtracking
      extend Forwardable

      ORDERING_ALGORITHM = Ordering::NoOrder
      FILTERING_ALGORITHM = Filtering::NoFilter
      LOOKAHEAD_ALGORITHM = Lookahead::NoAlgorithm

      attr_reader :problem, :solutions, :max_solutions,
                  :ordering_algorithm, :filtering_algorithm, :lookahead_algorithm

      def_delegators :problem, :variables, :constraints

      def initialize(
        problem:,
        ordering_algorithm: nil,
        filtering_algorithm: nil,
        lookahead_algorithm: nil,
        max_solutions: 1
      )
        @problem = problem
        @ordering_algorithm = ordering_algorithm || ORDERING_ALGORITHM.new(problem)
        @filtering_algorithm = filtering_algorithm || FILTERING_ALGORITHM.new(problem)
        @lookahead_algorithm = lookahead_algorithm || LOOKAHEAD_ALGORITHM.new(problem)
        @max_solutions = max_solutions
        @solutions = []
      end

      def backtracking(assignment = {})
        backtracking_recursion(assignment, problem_domains)
      end

      def consistent?(variable, assignment)
        constraints[variable].all? do |constraint|
          constraint.satisfies?(assignment)
        end
      end

      private

      def problem_domains
        problem.domains
      end

      def backtracking_recursion(assignment, domains)
        return solutions if max_solutions?
        return add_solution(assignment) if complete?(assignment)

        unassigned = next_unassigned_variable(assignment)

        domains_for(unassigned, assignment, domains).each do |value|
          local_assignment = assignment.clone
          local_assignment[unassigned] = value

          next unless consistent?(unassigned, local_assignment)

          new_domains = lookahead(local_assignment, domains)

          next unless new_domains

          backtracking_recursion(local_assignment, new_domains)

          return solutions if max_solutions?
        end

        []
      end

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

      def domains_for(unassigned, assignment, domains)
        filtering_algorithm.call(
          values: domains[unassigned],
          assignment_values: assignment.values.flatten
        )
      end

      def lookahead(assignment, domains)
        lookahead_algorithm.call(
          variables: variables,
          assignment: assignment,
          domains: domains
        )
      end
    end
  end
end
