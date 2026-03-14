# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveAlchemy::Helpers::AlchemyEngine do
  subject(:engine) { described_class.new }

  let(:substance) do
    engine.create_substance(element_type: :concept, domain: :reasoning,
                            content: 'test idea')
  end

  describe '#create_substance' do
    it 'creates and stores a substance' do
      sub = engine.create_substance(element_type: :belief, domain: :ethics,
                                    content: 'moral axiom')
      expect(sub).to be_a(Legion::Extensions::CognitiveAlchemy::Helpers::Substance)
    end

    it 'raises when athanor is full' do
      stub_const('Legion::Extensions::CognitiveAlchemy::Helpers::Constants::MAX_SUBSTANCES', 1)
      engine.create_substance(element_type: :concept, domain: :x, content: 'a')
      expect { engine.create_substance(element_type: :concept, domain: :x, content: 'b') }
        .to raise_error(ArgumentError, /athanor full/)
    end
  end

  describe '#advance_stage' do
    it 'advances the substance stage' do
      engine.advance_stage(substance_id: substance.id)
      expect(substance.stage).to eq(:albedo)
    end

    it 'raises for unknown substance' do
      expect { engine.advance_stage(substance_id: 'nope') }
        .to raise_error(ArgumentError, /substance not found/)
    end
  end

  describe '#catalyze' do
    it 'boosts purity with philosopher stone' do
      old = substance.purity
      engine.catalyze(substance_id: substance.id)
      expect(substance.purity).to be > old
    end
  end

  describe '#react' do
    it 'combines two substances' do
      s1 = engine.create_substance(element_type: :concept, domain: :logic, content: 'premise')
      s2 = engine.create_substance(element_type: :concept, domain: :logic, content: 'conclusion')
      result = engine.react(reaction_type: :conjunction, input_ids: [s1.id, s2.id])
      expect(result[:output]).to be_a(Legion::Extensions::CognitiveAlchemy::Helpers::Substance)
      expect(result[:crucible].completed?).to be true
    end

    it 'increases purity from high-intensity reactions' do
      s1 = engine.create_substance(element_type: :skill, domain: :craft, content: 'a')
      s2 = engine.create_substance(element_type: :skill, domain: :craft, content: 'b')
      result = engine.react(reaction_type: :calcination, input_ids: [s1.id, s2.id],
                            heat: 0.9, pressure: 0.9)
      expect(result[:output].purity).to be > s1.purity
    end

    it 'raises for too many reactions' do
      stub_const('Legion::Extensions::CognitiveAlchemy::Helpers::Constants::MAX_REACTIONS', 0)
      s1 = engine.create_substance(element_type: :concept, domain: :x, content: 'a')
      s2 = engine.create_substance(element_type: :concept, domain: :x, content: 'b')
      expect { engine.react(reaction_type: :dissolution, input_ids: [s1.id, s2.id]) }
        .to raise_error(ArgumentError, /too many reactions/)
    end
  end

  describe '#decay_all!' do
    it 'decays all substances' do
      substance
      old = substance.potency
      engine.decay_all!
      expect(substance.potency).to be < old
    end

    it 'prunes inert substances' do
      s = engine.create_substance(element_type: :emotion, domain: :x,
                                  content: 'dead', potency: 0.01)
      engine.decay_all!(rate: 0.5)
      expect(engine.all_substances).not_to include(s)
    end
  end

  describe '#substances_by_stage' do
    it 'returns counts by stage' do
      substance
      result = engine.substances_by_stage
      expect(result[:nigredo]).to eq(1)
    end
  end

  describe '#substances_by_type' do
    it 'returns counts by element type' do
      substance
      result = engine.substances_by_type
      expect(result[:concept]).to eq(1)
    end
  end

  describe '#gold_count' do
    it 'counts gold substances' do
      3.times { substance.advance_stage! }
      substance.catalyze!
      expect(engine.gold_count).to eq(1)
    end
  end

  describe '#prima_materia_count' do
    it 'counts prima materia' do
      substance
      expect(engine.prima_materia_count).to eq(1)
    end
  end

  describe '#purest' do
    it 'returns substances sorted by purity' do
      s1 = engine.create_substance(element_type: :concept, domain: :x, content: 'a', purity: 0.9)
      engine.create_substance(element_type: :concept, domain: :x, content: 'b', purity: 0.1)
      expect(engine.purest(limit: 1).first).to eq(s1)
    end
  end

  describe '#most_potent' do
    it 'returns substances sorted by potency' do
      s1 = engine.create_substance(element_type: :belief, domain: :x, content: 'a', potency: 0.95)
      engine.create_substance(element_type: :belief, domain: :x, content: 'b', potency: 0.1)
      expect(engine.most_potent(limit: 1).first).to eq(s1)
    end
  end

  describe '#alchemy_report' do
    it 'returns a comprehensive report' do
      substance
      report = engine.alchemy_report
      %i[total_substances total_reactions by_stage by_type
         gold_count prima_materia avg_purity avg_potency].each do |k|
        expect(report).to have_key(k)
      end
    end
  end
end
