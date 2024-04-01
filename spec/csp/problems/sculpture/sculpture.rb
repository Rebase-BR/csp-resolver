# frozen_string_literal: true

require 'csp/problems/examples/sculpture'

RSpec.describe CSP::Problems::Sculpture do
  describe '.call' do
    it 'instantiate and invokes the call method' do
      instance = double('Sculpture', call: true)

      allow(described_class)
        .to receive(:new)
        .and_return(instance)

      described_class.call

      expect(instance).to have_received(:call)
    end
  end

  describe '#call' do
    it 'returns the solution for the problem' do
      expect(described_class.call).to eq({ A => 2, B => 1, C => 1 })
    end
  end
end
