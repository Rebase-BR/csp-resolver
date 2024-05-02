# frozen_string_literal: true

require_relative 'csp/version'
require_relative 'csp/constraint'
require_relative 'csp/utils'
require_relative 'csp/algorithms/filtering/no_filter'
require_relative 'csp/algorithms/ordering/no_order'
require_relative 'csp/algorithms/lookahead/no_algorithm'
require_relative 'csp/algorithms/lookahead/ac3'
require_relative 'csp/algorithms/backtracking'
require_relative 'csp/constraints'
require_relative 'csp/problem'

module CSP; end
