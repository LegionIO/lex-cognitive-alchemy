# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveAlchemy::Runners::CognitiveAlchemy do
  let(:engine) { Legion::Extensions::CognitiveAlchemy::Helpers::AlchemyEngine.new }

  describe '.create_substance' do
    it 'returns success with substance hash' do
      result = described_class.create_substance(
        element_type: :concept, domain: :reasoning, content: 'new idea', engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:substance][:element_type]).to eq(:concept)
    end

    it 'returns failure for invalid type' do
      result = described_class.create_substance(
        element_type: :unobtanium, domain: :x, content: 'y', engine: engine
      )
      expect(result[:success]).to be false
      expect(result[:error]).to match(/unknown element type/)
    end
  end

  describe '.advance_stage' do
    it 'advances and returns updated substance' do
      sub = engine.create_substance(element_type: :belief, domain: :ethics, content: 'test')
      result = described_class.advance_stage(substance_id: sub.id, engine: engine)
      expect(result[:success]).to be true
      expect(result[:substance][:stage]).to eq(:albedo)
    end

    it 'returns failure for missing substance' do
      result = described_class.advance_stage(substance_id: 'nope', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '.catalyze' do
    it 'catalyzes substance' do
      sub = engine.create_substance(element_type: :skill, domain: :craft, content: 'test')
      result = described_class.catalyze(substance_id: sub.id, engine: engine)
      expect(result[:success]).to be true
      expect(result[:substance][:purity]).to be > 0.1
    end
  end

  describe '.react' do
    it 'combines substances via crucible' do
      s1 = engine.create_substance(element_type: :concept, domain: :logic, content: 'a')
      s2 = engine.create_substance(element_type: :concept, domain: :logic, content: 'b')
      result = described_class.react(
        reaction_type: :conjunction, input_ids: [s1.id, s2.id], engine: engine
      )
      expect(result[:success]).to be true
      expect(result[:crucible][:completed]).to be true
      expect(result[:output][:element_type]).to eq(:concept)
    end

    it 'returns failure for invalid reaction type' do
      result = described_class.react(
        reaction_type: :explode, input_ids: [], engine: engine
      )
      expect(result[:success]).to be false
    end
  end

  describe '.list_substances' do
    it 'returns all substances' do
      engine.create_substance(element_type: :concept, domain: :x, content: 'a')
      engine.create_substance(element_type: :belief, domain: :y, content: 'b')
      result = described_class.list_substances(engine: engine)
      expect(result[:success]).to be true
      expect(result[:count]).to eq(2)
    end

    it 'filters by stage' do
      s = engine.create_substance(element_type: :concept, domain: :x, content: 'a')
      s.advance_stage!
      engine.create_substance(element_type: :concept, domain: :x, content: 'b')
      result = described_class.list_substances(engine: engine, stage: :albedo)
      expect(result[:count]).to eq(1)
    end

    it 'filters by element_type' do
      engine.create_substance(element_type: :concept, domain: :x, content: 'a')
      engine.create_substance(element_type: :belief, domain: :x, content: 'b')
      result = described_class.list_substances(engine: engine, element_type: :concept)
      expect(result[:count]).to eq(1)
    end
  end

  describe '.alchemy_status' do
    it 'returns a report' do
      result = described_class.alchemy_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to have_key(:total_substances)
    end
  end
end
