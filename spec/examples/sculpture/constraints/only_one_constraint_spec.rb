# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../examples/event_scheduling'

RSpec.describe CSP::Examples::EventScheduling::OnlyOneConstraint do
  describe '#satisfies?' do
    context 'when both events are assigned different time slots' do
      it 'returns true' do
        assignment = {
          0 => 0,
          1 => 1
        }
        constraint = described_class.new(0, 1)
        expect(constraint.satisfies?(assignment)).to eq true
      end
    end

    context 'when both events are assigned the same time slot' do
      it 'returns false' do
        assignment = {
          0 => 1,
          1 => 1
        }
        constraint = described_class.new(0, 1)
        expect(constraint.satisfies?(assignment)).to eq false
      end
    end

    context 'when one of the events is not assigned a time slot' do
      it 'returns true' do
        assignment = {
          0 => 1
        }
        constraint = described_class.new(0, 1)
        expect(constraint.satisfies?(assignment)).to eq true
      end
    end

    context 'when neither of the events are assigned a time slot' do
      it 'returns true' do
        assignment = {}
        constraint = described_class.new(0, 1)
        expect(constraint.satisfies?(assignment)).to eq true
      end
    end
  end
end
