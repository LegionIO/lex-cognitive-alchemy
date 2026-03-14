# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveAlchemy
      module Helpers
        class AlchemyEngine
          def initialize
            @substances = {}
            @reactions  = {}
          end

          def create_substance(element_type:, domain:, content:, purity: nil, potency: nil)
            raise ArgumentError, 'athanor full' if @substances.size >= Constants::MAX_SUBSTANCES

            sub = Substance.new(element_type: element_type, domain: domain,
                                content: content, purity: purity, potency: potency)
            @substances[sub.id] = sub
            sub
          end

          def advance_stage(substance_id:)
            fetch_substance(substance_id).advance_stage!
          end

          def catalyze(substance_id:, multiplier: Constants::CATALYST_MULTIPLIER)
            fetch_substance(substance_id).catalyze!(multiplier: multiplier)
          end

          def react(reaction_type:, input_ids:, heat: 0.5, pressure: 0.5)
            raise ArgumentError, 'too many reactions' if @reactions.size >= Constants::MAX_REACTIONS

            inputs = input_ids.map { |id| fetch_substance(id) }
            crucible = Crucible.new(reaction_type: reaction_type, input_ids: input_ids,
                                    heat: heat, pressure: pressure)

            output = synthesize(inputs, crucible)
            @substances[output.id] = output
            crucible.complete!(output.id)
            @reactions[crucible.id] = crucible

            { crucible: crucible, output: output }
          end

          def decay_all!(rate: Constants::SUBSTANCE_DECAY)
            @substances.each_value { |s| s.decay!(rate: rate) }
            pruned = @substances.select { |_, s| s.inert? }.keys
            pruned.each { |id| @substances.delete(id) }
            { decayed: @substances.size, pruned: pruned.size }
          end

          def substances_by_stage
            counts = Constants::STAGES.to_h { |s| [s, 0] }
            @substances.each_value { |s| counts[s.stage] += 1 }
            counts
          end

          def substances_by_type
            counts = Constants::ELEMENT_TYPES.to_h { |t| [t, 0] }
            @substances.each_value { |s| counts[s.element_type] += 1 }
            counts
          end

          def gold_count
            @substances.count { |_, s| s.gold? }
          end

          def prima_materia_count
            @substances.count { |_, s| s.prima_materia? }
          end

          def purest(limit: 5)
            @substances.values.sort_by { |s| -s.purity }.first(limit)
          end

          def most_potent(limit: 5)
            @substances.values.sort_by { |s| -s.potency }.first(limit)
          end

          def alchemy_report
            {
              total_substances: @substances.size,
              total_reactions:  @reactions.size,
              by_stage:         substances_by_stage,
              by_type:          substances_by_type,
              gold_count:       gold_count,
              prima_materia:    prima_materia_count,
              avg_purity:       avg_metric(:purity),
              avg_potency:      avg_metric(:potency)
            }
          end

          def all_substances
            @substances.values
          end

          def all_reactions
            @reactions.values
          end

          private

          def fetch_substance(id)
            @substances.fetch(id) do
              raise ArgumentError, "substance not found: #{id}"
            end
          end

          def synthesize(inputs, crucible)
            avg_purity  = inputs.sum(&:purity) / inputs.size
            avg_potency = inputs.sum(&:potency) / inputs.size
            boost       = crucible.intensity * Constants::TRANSMUTATION_RATE

            create_substance(
              element_type: inputs.first.element_type,
              domain:       inputs.first.domain,
              content:      "synthesis(#{inputs.map(&:content).join(' + ')})",
              purity:       (avg_purity + boost).clamp(0.0, 1.0),
              potency:      (avg_potency + (boost * 0.5)).clamp(0.0, 1.0)
            )
          end

          def avg_metric(attr)
            return 0.0 if @substances.empty?

            (substances_metric_sum(attr) / @substances.size).round(10)
          end

          def substances_metric_sum(attr)
            @substances.values.sum(&attr)
          end
        end
      end
    end
  end
end
