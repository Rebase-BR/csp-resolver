# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'filter or ordering algorithm initializes with problem' do
  describe '.for' do
    context 'when receives a problem (csp) and dependency' do
      it ' initialize using problem' do
        problem = spy
        dependency = spy

        order_or_filter = described_class.for(problem:, dependency:)

        expect(order_or_filter).to have_attributes(class: described_class, problem:)
      end
    end

    context 'when no dependency is received' do
      it 'initialize using problem' do
        problem = spy

        order_or_filter = described_class.for(problem:)

        expect(order_or_filter).to have_attributes(class: described_class, problem:)
      end
    end
  end
end
