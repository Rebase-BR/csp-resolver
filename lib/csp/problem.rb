# frozen_string_literal: true

require_relative 'algorithms/backtracking'
require_relative 'utils'
require_relative 'constraints'

module CSP
  # TODO: implement dependent factor with weight
  # TODO: implement lookahead, arc-consistency, ac3
  class Problem
    include CSP::Constraints

    attr_reader :variables, :domains, :constraints, :max_solutions,
                :ordering_algorithm, :filtering_algorithm, :lookahead_algorithm

    InvalidConstraintVariable = Class.new(StandardError)
    VariableShouldNotBeEmpty = Class.new(StandardError)
    DomainsShouldNotBeEmpty = Class.new(StandardError)
    VariableAlreadySeted = Class.new(StandardError)

    def initialize(max_solutions: 1)
      @variables = []
      @domains = {}
      @constraints = {}
      @max_solutions = max_solutions
    end

    def solve(assignment = {})
      Utils::Array.wrap(search_solution(assignment))
    end

    def add_variable(variable, domains:)
      if (variable.respond_to?(:empty?) && variable.empty?) || variable.nil?
        raise VariableShouldNotBeEmpty, 'Variable was empty in the function parameter'
      end
      raise DomainsShouldNotBeEmpty, 'Domains was empty in the function parameter' if domains.empty?
      raise VariableAlreadySeted, "Variable #{variable} has already been seted" if variables.include?(variable)

      variables << variable
      @domains[variable] = domains
      constraints[variable] = []

      self
    end

    def add_variables(variables, domains:)
      variables.each do |variable|
        add_variable(variable, domains: domains)
      end

      self
    end

    def add_constraint(constraint = nil, variables: nil, &block)
      validate_parameters(constraint, variables, block)

      constraint = CustomConstraint.new(variables, block) if block

      constraint.variables.each do |variable|
        next constraints[variable] << constraint if constraints.include?(variable)

        raise InvalidConstraintVariable,
              "Constraint's variable doesn't exists in CSP"
      end

      self
    end

    def add_ordering(ordering_algorithm)
      @ordering_algorithm = ordering_algorithm
    end

    def add_filtering(filtering_algorithm)
      @filtering_algorithm = filtering_algorithm
    end

    def add_lookahead(lookahead_algorithm)
      @lookahead_algorithm = lookahead_algorithm
    end

    private

    def validate_parameters(constraint, variables, block)
      if missing_both_constraint_and_block?(constraint, block)
        raise ArgumentError, 'Either constraint or block must be provided'
      end
      if provided_both_constraint_and_block?(constraint, block)
        raise ArgumentError, 'Both constraint and block cannot be provided at the same time'
      end
      if missing_variables_for_block?(block, variables)
        raise ArgumentError, 'Variables must be provided when using a block'
      end
      return unless block_arity_exceeds_variables?(block, variables)

      raise ArgumentError, 'Block should not have more arity than the quantity of variables'
    end

    def missing_both_constraint_and_block?(constraint, block)
      constraint.nil? && block.nil?
    end

    def provided_both_constraint_and_block?(constraint, block)
      constraint && block
    end

    def missing_variables_for_block?(block, variables)
      block && variables.nil?
    end

    def block_arity_exceeds_variables?(block, variables)
      !variables.nil? && block.arity > variables.length
    end

    def search_solution(assignment = {})
      algorithm.backtracking(assignment)
    end

    def algorithm
      Algorithms::Backtracking.new(
        problem: self,
        ordering_algorithm: ordering_algorithm,
        filtering_algorithm: filtering_algorithm,
        lookahead_algorithm: lookahead_algorithm,
        max_solutions: max_solutions
      )
    end
  end
end
