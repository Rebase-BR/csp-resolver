# frozen_string_literal: true

require_relative '../../../shared/algorithms/filtering&ordering'

RSpec.describe CSP::Algorithms::Filtering::NoFilter do
  it_behaves_like 'filter or ordering algorithm initializes with problem'

  describe '#call' do
    it 'returns the values without any change' do
      problem = spy
      values = [1, 2, 3]

      filter_algorithm = described_class.new(problem)

      filtered_variables = filter_algorithm.call(values:, assignment_values: [])

      expect(filtered_variables).to eq [1, 2, 3]
    end
  end
end
