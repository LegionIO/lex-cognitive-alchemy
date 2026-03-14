# lex-cognitive-alchemy

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Alchemical metaphor for cognitive transformation — substances move through four Jungian stages (nigredo, albedo, citrinitas, rubedo) via reactions and catalysts, modeling irreversible knowledge refinement and insight synthesis.

## Gem Info

- **Gem name**: `lex-cognitive-alchemy`
- **Version**: `0.1.0`
- **Module**: `Legion::Extensions::CognitiveAlchemy`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_alchemy/
  cognitive_alchemy.rb           # Main extension module
  version.rb                     # VERSION = '0.1.0'
  client.rb                      # Client wrapper
  helpers/
    constants.rb                 # Stages, element types, reaction types, multipliers, labels
    substance.rb                 # Substance value object (stage, purity, potency, element_type)
    alchemy_engine.rb            # AlchemyEngine — manages substances, reactions, stage progression
  runners/
    cognitive_alchemy.rb         # Runner module (extend self) with 7 public methods
spec/
  (spec files)
```

## Key Constants

```ruby
STAGES = %i[nigredo albedo citrinitas rubedo]
ELEMENT_TYPES = %i[fire water earth air aether]
REACTION_TYPES = %i[synthesis decomposition transmutation catalysis dissolution]
CATALYST_MULTIPLIER = 3.0       # catalyst reactions multiply purity/potency gain by 3x
PURITY_LABELS = {
  (0.9..) => :refined, (0.7...0.9) => :purified, (0.5...0.7) => :mixed,
  (0.3...0.5) => :impure, (..0.3) => :crude
}
POTENCY_LABELS = {
  (0.85..) => :transcendent, (0.65...0.85) => :potent, (0.45...0.65) => :moderate,
  (0.25...0.45) => :weak, (..0.25) => :inert
}
STAGE_LABELS = {
  nigredo: :decomposition, albedo: :purification,
  citrinitas: :illumination, rubedo: :completion
}
```

## Runners

### `Runners::CognitiveAlchemy`

Uses `extend self` — methods are module-level, not instance-delegating. Delegates to a per-call `engine` (parameter-injected `Helpers::AlchemyEngine` instance via `engine:` keyword, defaulting to a shared `@engine ||=`).

- `create_substance(name:, element_type:, domain: :general, engine: @engine)` — create a new alchemical substance at `:nigredo` stage with default purity/potency
- `advance_stage(substance_id:, engine: @engine)` — move substance to the next STAGES entry; no-op at `:rubedo`
- `catalyze(substance_id:, catalyst:, engine: @engine)` — apply a catalyst to a substance, multiplying its purity and potency gain by `CATALYST_MULTIPLIER`
- `react(substance_id:, reagent_id:, reaction_type:, engine: @engine)` — apply a typed reaction between two substances; returns reaction outcome hash
- `list_substances(engine: @engine)` — all substances as array of hashes
- `alchemy_status(engine: @engine)` — summary stats: substance count, stage distribution, average purity/potency

## Helpers

### `Helpers::AlchemyEngine`
Core engine managing `@substances` hash keyed by ID. `advance_stage` cycles through `STAGES` array index. `catalyze` applies `CATALYST_MULTIPLIER` to substance attribute update. `react` looks up both substances, applies reaction effects based on `reaction_type`, and returns outcome. `substance_list` returns all substances as serialized hashes.

### `Helpers::Substance`
Value object: name, element_type, domain, stage (starts at `:nigredo`), purity (0.0–1.0), potency (0.0–1.0), reaction_count. `advance!` bumps stage via STAGES index. `refine!(amount)` increases purity clamped to 1.0. `empower!(amount)` increases potency clamped to 1.0. `purity_label` and `potency_label` map to human-readable labels.

## Integration Points

No actor defined — no automatic decay or scanning. This is a transformation metaphor: raw observations enter at `:nigredo` and move through stages as evidence accumulates. Pairs with lex-causal-reasoning (causal chains can trigger stage advancement) and lex-abductive-reasoning (best explanations emerge at `:rubedo`). The CATALYST_MULTIPLIER (3x) models insight events — moments where a catalyst dramatically accelerates refinement.

## Development Notes

- `extend self` pattern means the runner is a module with module-level methods — no `@engine` instance variable in a class; shared state lives in the module's singleton
- `advance_stage` is a no-op when substance is already at `:rubedo` — callers should check stage before calling
- `CATALYST_MULTIPLIER = 3.0` is the only numeric constant that differs from the standard 0.1/0.15 rates used by other extensions
- Stage ordering is fixed by the `STAGES` array index; array order defines the progression
