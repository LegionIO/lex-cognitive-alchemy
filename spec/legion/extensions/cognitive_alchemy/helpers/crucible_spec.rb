# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveAlchemy::Helpers::Crucible do
  subject(:crucible) do
    described_class.new(reaction_type: :calcination, input_ids: %w[a1 b2])
  end

  describe '#initialize' do
    it 'sets reaction type' do
      expect(crucible.reaction_type).to eq(:calcination)
    end

    it 'stores input ids' do
      expect(crucible.input_ids).to eq(%w[a1 b2])
    end

    it 'generates uuid' do
      expect(crucible.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'defaults heat to 0.5' do
      expect(crucible.heat).to eq(0.5)
    end

    it 'defaults pressure to 0.5' do
      expect(crucible.pressure).to eq(0.5)
    end

    it 'starts uncompleted' do
      expect(crucible.completed?).to be false
    end

    it 'rejects unknown reaction types' do
      expect { described_class.new(reaction_type: :transmorgify, input_ids: []) }
        .to raise_error(ArgumentError, /unknown reaction type/)
    end

    it 'accepts custom heat' do
      c = described_class.new(reaction_type: :dissolution, input_ids: [], heat: 0.9)
      expect(c.heat).to eq(0.9)
    end

    it 'clamps pressure' do
      c = described_class.new(reaction_type: :dissolution, input_ids: [], pressure: 2.0)
      expect(c.pressure).to eq(1.0)
    end
  end

  describe '#complete!' do
    it 'marks as completed' do
      crucible.complete!('output-1')
      expect(crucible.completed?).to be true
    end

    it 'stores output id' do
      crucible.complete!('output-1')
      expect(crucible.output_id).to eq('output-1')
    end

    it 'records completion time' do
      crucible.complete!('output-1')
      expect(crucible.completed_at).to be_a(Time)
    end
  end

  describe '#intensity' do
    it 'averages heat and pressure' do
      expect(crucible.intensity).to eq(0.5)
    end

    it 'reflects custom values' do
      c = described_class.new(reaction_type: :conjunction, input_ids: [],
                              heat: 0.8, pressure: 0.4)
      expect(c.intensity).to eq(0.6)
    end
  end

  describe '#volatile?' do
    it 'returns false at normal levels' do
      expect(crucible.volatile?).to be false
    end

    it 'returns true at extreme levels' do
      c = described_class.new(reaction_type: :calcination, input_ids: [],
                              heat: 0.9, pressure: 0.9)
      expect(c.volatile?).to be true
    end
  end

  describe '#mild?' do
    it 'returns false at normal intensity' do
      expect(crucible.mild?).to be false
    end

    it 'returns true at low intensity' do
      c = described_class.new(reaction_type: :distillation, input_ids: [],
                              heat: 0.1, pressure: 0.1)
      expect(c.mild?).to be true
    end
  end

  describe '#to_h' do
    it 'returns a hash with all keys' do
      h = crucible.to_h
      %i[id reaction_type input_ids output_id heat pressure
         intensity volatile mild started_at completed_at completed].each do |k|
        expect(h).to have_key(k)
      end
    end
  end
end
