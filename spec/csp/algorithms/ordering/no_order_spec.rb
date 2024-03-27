# frozen_string_literal: true

RSpec.describe CSP::Algorithms::Ordering::NoOrder do
  it_behaves_like 'filter algorithm initializes with problem'

  describe '#call' do
    it 'returns the values in same order' do
      problem = spy
      variables = [1, 2, 3]

      order_algorithm = described_class.new(problem)

      expect(order_algorithm.call(variables)).to eq [1, 2, 3]
    end
  end
end
