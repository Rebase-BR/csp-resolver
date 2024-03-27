# frozen_string_literal: true

require_relative 'algorithms/backtracking'
require 'active_support'
require 'active_support/core_ext'
require_relative 'utils'

module CSP
  # TODO: implement dependent factor with weight
  # TODO: implement lookahead, arc-consistency, ac3
  class Problem
    attr_reader :variables, :domains, :constraints, :max_solutions,
                :ordering_algorithm, :filtering_algorithm

    MissingDomain = Class.new(StandardError)
    MissingVariable = Class.new(StandardError)

    def initialize(variables: [], domains: {}, max_solutions: 1)
      @variables = variables
      @domains = domains
      @constraints = {}
      @max_solutions = max_solutions

      @ordering_algorithm = nil
      @filtering_algorithm = nil

      setup_constraints
    end

    def solve(assignment = {})
      Utils::Array.wrap(search_solution(assignment))
    end

    def add_constraint(constraint)
      constraint.variables.each do |variable|
        next constraints[variable] << constraint if constraints.include?(variable)

        raise MissingVariable,
              "Constraint's variable doesn't exists in CSP"
      end

      true
    end

    def add_ordering(ordering_algorithm)
      @ordering_algorithm = ordering_algorithm
    end

    def add_filtering(filtering_algorithm)
      @filtering_algorithm = filtering_algorithm
    end

    private

    def search_solution(assignment = {})
      algorithm.backtracking(assignment)
    end

    def algorithm
      Algorithms::Backtracking.new(
        problem: self,
        ordering_algorithm:,
        filtering_algorithm:,
        max_solutions:
      )
    end

    def setup_constraints
      variables.each do |variable|
        constraints[variable] = []

        next if domains.key?(variable)

        raise MissingDomain,
              "Variable #{variable} does not have a domain assigned"
      end
    end
  end
end
