# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveAlchemy::Helpers::Constants do
  describe 'STAGES' do
    it 'has four stages in correct order' do
      expect(described_class::STAGES).to eq(%i[nigredo albedo citrinitas rubedo])
    end

    it 'is frozen' do
      expect(described_class::STAGES).to be_frozen
    end
  end

  describe 'ELEMENT_TYPES' do
    it 'includes core types' do
      %i[concept belief skill memory emotion].each do |t|
        expect(described_class::ELEMENT_TYPES).to include(t)
      end
    end
  end

  describe 'REACTION_TYPES' do
    it 'includes seven classical reactions' do
      expect(described_class::REACTION_TYPES.size).to eq(7)
    end
  end

  describe '.label_for' do
    it 'returns aurum for high purity' do
      expect(described_class.label_for(described_class::PURITY_LABELS, 0.9)).to eq(:aurum)
    end

    it 'returns plumbum for low purity' do
      expect(described_class.label_for(described_class::PURITY_LABELS, 0.1)).to eq(:plumbum)
    end

    it 'returns transcendent for high potency' do
      expect(described_class.label_for(described_class::POTENCY_LABELS, 0.85)).to eq(:transcendent)
    end

    it 'returns inert for low potency' do
      expect(described_class.label_for(described_class::POTENCY_LABELS, 0.05)).to eq(:inert)
    end
  end
end
