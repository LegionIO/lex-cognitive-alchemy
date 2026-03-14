# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveAlchemy::Helpers::Substance do
  subject(:substance) do
    described_class.new(element_type: :concept, domain: :reasoning,
                        content: 'test idea')
  end

  describe '#initialize' do
    it 'sets element_type' do
      expect(substance.element_type).to eq(:concept)
    end

    it 'sets domain' do
      expect(substance.domain).to eq(:reasoning)
    end

    it 'sets content' do
      expect(substance.content).to eq('test idea')
    end

    it 'starts in nigredo stage' do
      expect(substance.stage).to eq(:nigredo)
    end

    it 'generates a uuid' do
      expect(substance.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'defaults purity to 0.1' do
      expect(substance.purity).to eq(0.1)
    end

    it 'defaults potency to 0.5' do
      expect(substance.potency).to eq(0.5)
    end

    it 'starts with zero transmutations' do
      expect(substance.transmutation_count).to eq(0)
    end

    it 'rejects unknown element types' do
      expect { described_class.new(element_type: :unobtanium, domain: :x, content: 'y') }
        .to raise_error(ArgumentError, /unknown element type/)
    end

    it 'accepts custom purity' do
      s = described_class.new(element_type: :belief, domain: :ethics, content: 'x', purity: 0.7)
      expect(s.purity).to eq(0.7)
    end

    it 'clamps purity above 1.0' do
      s = described_class.new(element_type: :skill, domain: :craft, content: 'x', purity: 5.0)
      expect(s.purity).to eq(1.0)
    end
  end

  describe '#advance_stage!' do
    it 'advances from nigredo to albedo' do
      substance.advance_stage!
      expect(substance.stage).to eq(:albedo)
    end

    it 'increases purity' do
      old = substance.purity
      substance.advance_stage!
      expect(substance.purity).to be > old
    end

    it 'increments transmutation count' do
      substance.advance_stage!
      expect(substance.transmutation_count).to eq(1)
    end

    it 'advances through all four stages' do
      3.times { substance.advance_stage! }
      expect(substance.stage).to eq(:rubedo)
    end

    it 'does not advance past rubedo' do
      4.times { substance.advance_stage! }
      expect(substance.stage).to eq(:rubedo)
    end
  end

  describe '#decay!' do
    it 'decreases potency' do
      old = substance.potency
      substance.decay!
      expect(substance.potency).to be < old
    end

    it 'does not go below zero' do
      50.times { substance.decay!(rate: 0.5) }
      expect(substance.potency).to eq(0.0)
    end
  end

  describe '#catalyze!' do
    it 'boosts purity significantly' do
      old = substance.purity
      substance.catalyze!
      expect(substance.purity).to be > old
    end

    it 'boosts potency' do
      old = substance.potency
      substance.catalyze!
      expect(substance.potency).to be > old
    end

    it 'increments transmutation count' do
      substance.catalyze!
      expect(substance.transmutation_count).to eq(1)
    end
  end

  describe '#prima_materia?' do
    it 'returns true for nigredo with low purity' do
      expect(substance.prima_materia?).to be true
    end

    it 'returns false after advancement' do
      substance.advance_stage!
      expect(substance.prima_materia?).to be false
    end
  end

  describe '#gold?' do
    it 'returns false initially' do
      expect(substance.gold?).to be false
    end

    it 'returns true at rubedo with high purity' do
      3.times { substance.advance_stage! }
      substance.catalyze!
      expect(substance.gold?).to be true
    end
  end

  describe '#inert?' do
    it 'returns false with normal potency' do
      expect(substance.inert?).to be false
    end

    it 'returns true after heavy decay' do
      50.times { substance.decay!(rate: 0.5) }
      expect(substance.inert?).to be true
    end
  end

  describe '#purity_label' do
    it 'returns a symbol' do
      expect(substance.purity_label).to be_a(Symbol)
    end
  end

  describe '#potency_label' do
    it 'returns a symbol' do
      expect(substance.potency_label).to be_a(Symbol)
    end
  end

  describe '#to_h' do
    it 'returns a hash with all keys' do
      h = substance.to_h
      %i[id element_type domain content stage purity potency
         prima_materia gold inert purity_label potency_label
         stage_label transmutation_count discovered_at].each do |k|
        expect(h).to have_key(k)
      end
    end
  end
end
