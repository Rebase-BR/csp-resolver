# frozen_string_literal: true

module CSP
  module Algorithms
    module Lookahead
      class Ac3
        attr_reader :problem

        def initialize(problem)
          @problem = problem
        end

        def call(variables:, assignment:, domains:)
          new_domains = variables.each_with_object({}) do |variable, new_domains|
            variable_domains = Array(assignment[variable] || domains[variable])

            new_domains[variable] = unary_check(variable, variable_domains)
          end

          variable_arcs = arcs(variables)

          arc_consistency(variable_arcs, new_domains)
        end

        def arc_consistency(arcs, domains)
          queue = arcs.dup

          until queue.empty?
            arc, *queue = queue
            x, y = arc.keys.first
            constraint = arc.values.first

            if arc_reduce(x, y, constraint, domains)
              if domains[x].empty?
                return nil
              else
                new_arcs = find_arcs(x, y, arcs)
                queue.push(*new_arcs)
              end
            end
          end

          domains
        end

        def arc_reduce(x, y, constraint, domains)
          changed = false
          x_domains = domains[x]
          y_domains = domains[y]

          x_domains.each do |x_value|
            consistent = y_domains.any? do |y_value|
              sat = constraint.satisfies?({ x => x_value, y => y_value })

              sat
            end

            next if consistent

            x_domains -= [x_value]
            changed = true
          end

          domains[x] = x_domains

          changed
        end

        # Returns all (z, x) arcs where z != y
        def find_arcs(x, y, arcs)
          arcs.select do |arc|
            arc.any? do |(first, second), _constraint|
              first != y && second == x
            end
          end
        end

        # Setup arcs between variables
        def arcs(variables)
          variables.each_with_object([]) do |variable, worklist|
            constraints = problem.constraints[variable].select(&:binary?)

            constraints.each do |constraint|
              variables_ij = [variable] | constraint.variables # make current variable be the first

              worklist << { variables_ij => constraint }
            end
          end
        end

        def unary_check(variable, variable_domains)
          constraints = problem.constraints[variable].select(&:unary?)

          variable_domains.select do |domain|
            constraints.all? do |constraint|
              constraint.satisfies?({ variable => domain })
            end
          end
        end
      end
    end
  end
end

