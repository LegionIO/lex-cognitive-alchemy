# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveAlchemy
      module Runners
        module CognitiveAlchemy
          extend self

          def create_substance(element_type:, domain:, content:,
                               purity: nil, potency: nil, engine: nil, **)
            eng = resolve_engine(engine)
            sub = eng.create_substance(element_type: element_type, domain: domain,
                                       content: content, purity: purity, potency: potency)
            { success: true, substance: sub.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def advance_stage(substance_id:, engine: nil, **)
            eng = resolve_engine(engine)
            sub = eng.advance_stage(substance_id: substance_id)
            { success: true, substance: sub.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def catalyze(substance_id:, multiplier: nil, engine: nil, **)
            eng  = resolve_engine(engine)
            opts = { substance_id: substance_id }
            opts[:multiplier] = multiplier if multiplier
            sub = eng.catalyze(**opts)
            { success: true, substance: sub.to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def react(reaction_type:, input_ids:, heat: 0.5,
                    pressure: 0.5, engine: nil, **)
            eng    = resolve_engine(engine)
            result = eng.react(reaction_type: reaction_type, input_ids: input_ids,
                               heat: heat, pressure: pressure)
            { success: true, crucible: result[:crucible].to_h,
              output: result[:output].to_h }
          rescue ArgumentError => e
            { success: false, error: e.message }
          end

          def list_substances(engine: nil, stage: nil, element_type: nil, **)
            eng     = resolve_engine(engine)
            results = filter_substances(eng.all_substances,
                                        stage: stage, element_type: element_type)
            { success: true, substances: results.map(&:to_h),
              count: results.size }
          end

          def alchemy_status(engine: nil, **)
            eng = resolve_engine(engine)
            { success: true, report: eng.alchemy_report }
          end

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          private

          def filter_substances(substances, stage:, element_type:)
            r = substances
            r = r.select { |s| s.stage == stage.to_sym } if stage
            r = r.select { |s| s.element_type == element_type.to_sym } if element_type
            r
          end

          def resolve_engine(engine)
            engine || default_engine
          end

          def default_engine
            @default_engine ||= Helpers::AlchemyEngine.new
          end
        end
      end
    end
  end
end
