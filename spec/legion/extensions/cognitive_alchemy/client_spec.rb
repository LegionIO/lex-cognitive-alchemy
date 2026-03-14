# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveAlchemy::Client do
  subject(:client) { described_class.new }

  it 'includes the runner module' do
    expect(client).to respond_to(:create_substance)
  end

  it 'includes all runner methods' do
    %i[create_substance advance_stage catalyze react
       list_substances alchemy_status].each do |m|
      expect(client).to respond_to(m)
    end
  end
end
