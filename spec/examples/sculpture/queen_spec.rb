# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../examples/queen'

RSpec.describe CSP::Examples::Queen do
  describe '#call' do
    it 'returns the solution for the problem' do
      expect(described_class.new.call).to eq([{ 0 => 0, 1 => 4, 2 => 7, 3 => 5, 4 => 2, 5 => 6, 6 => 1, 7 => 3 }])
    end
  end
end
