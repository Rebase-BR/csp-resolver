# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../examples/map_coloring'

RSpec.describe CSP::Examples::MapColoring do
  describe '#call' do
    it 'returns the solution for the problem' do
      expect(described_class.new.call).to eq([{ 'Western Australia' => 'red',
                                                'Northern Territory' => 'blue',
                                                'South Australia' => 'green',
                                                'Queensland' => 'red',
                                                'New South Wales' => 'blue',
                                                'Victoria' => 'red',
                                                'Tasmania' => 'blue' }])
    end
  end
end
