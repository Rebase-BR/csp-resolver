# frozen_string_literal: true

RSpec.shared_examples 'filter or ordering algorithm initializes with problem' do
  describe '.for' do
    context 'when receives a problem (csp) and dependency' do
      it ' initialize using problem' do
        problem = spy
        dependency = spy

        filter = described_class.for(problem:, dependency:)

        expect(filter).to have_attributes(class: described_class, problem:)
      end
    end

    context 'when no dependency is received' do
      it 'initialize using problem' do
        problem = spy

        filter = described_class.for(problem:)

        expect(filter).to have_attributes(class: described_class, problem:)
      end
    end
  end
end

RSpec.shared_examples 'filter algorithm initializes with dependency' do
  describe '.for' do
    context 'when receives a problem (csp) and dependency' do
      it ' initialize using dependency' do
        problem = spy
        dependency = spy

        filter = described_class.for(problem:, dependency:)

        expect(filter).to have_attributes(
          class: described_class,
          tournament: dependency
        )
      end
    end

    context 'when no problem is received' do
      it 'initialize using dependency' do
        dependency = spy

        filter = described_class.for(dependency:)

        expect(filter).to have_attributes(
          class: described_class,
          tournament: dependency
        )
      end
    end
  end
end
