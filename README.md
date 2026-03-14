# lex-cognitive-alchemy

Alchemical metaphor for cognitive transformation — substances move through Jungian stages via reactions and catalysts.

## What It Does

Models knowledge refinement as an alchemical process. Cognitive substances (ideas, insights, hypotheses) are created at the crude `:nigredo` stage and purified through four stages: nigredo (decomposition), albedo (purification), citrinitas (illumination), rubedo (completion). Reactions between substances transform them; catalysts multiply the gain by 3x.

## Core Concept: Stage Progression

```
nigredo -> albedo -> citrinitas -> rubedo
(crude)   (purified) (illuminated) (complete)
```

Each substance has `purity` (0.0–1.0, crude to refined) and `potency` (0.0–1.0, inert to transcendent). Stage advancement and reactions increase both.

## Usage

```ruby
client = Legion::Extensions::CognitiveAlchemy::Client.new

# Create substances from raw observations
idea = client.create_substance(name: :cache_invalidation_theory, element_type: :fire, domain: :infrastructure)
evidence = client.create_substance(name: :production_trace_data, element_type: :earth, domain: :infrastructure)

# Apply a reaction between substances
client.react(
  substance_id: idea[:substance][:id],
  reagent_id: evidence[:substance][:id],
  reaction_type: :synthesis
)

# A breakthrough insight acts as a catalyst (3x multiplier)
client.catalyze(substance_id: idea[:substance][:id], catalyst: :root_cause_confirmed)

# Advance to next stage when ready
client.advance_stage(substance_id: idea[:substance][:id])
# substance moves from :nigredo -> :albedo

# Check overall transformation progress
client.alchemy_status
# => { substance_count: 2, stage_distribution: { nigredo: 1, albedo: 1, ... }, avg_purity: 0.62 }
```

## Integration

Pairs with lex-causal-reasoning (causal chains can trigger stage advancement as evidence accumulates) and lex-abductive-reasoning (best explanations correspond to `:rubedo` substances — fully refined and potent).

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
