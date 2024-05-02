# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSP::Constraint do
  describe '#satisfies?' do
    context 'is not implemented yet' do
      it 'raises a NotImplementedError' do
        constraint = CSP::Constraint.new
        expect { constraint.satisfies? }.to raise_error(StandardError, 'Not Implemented. Should return a boolean')
      end
    end
  end
end
