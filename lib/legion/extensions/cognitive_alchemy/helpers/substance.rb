# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveAlchemy
      module Helpers
        class Substance
          attr_reader :id, :element_type, :domain, :content,
                      :stage, :discovered_at, :transmutation_count
          attr_accessor :purity, :potency

          def initialize(element_type:, domain:, content:,
                         purity: nil, potency: nil)
            validate_type!(element_type)
            assign_core(element_type, domain, content)
            assign_metadata(purity, potency)
          end

          def advance_stage!
            idx = Constants::STAGES.index(@stage)
            return self if idx >= Constants::STAGES.size - 1

            @stage = Constants::STAGES[idx + 1]
            @purity = (@purity + Constants::TRANSMUTATION_RATE).clamp(0.0, 1.0).round(10)
            @transmutation_count += 1
            self
          end

          def decay!(rate: Constants::SUBSTANCE_DECAY)
            @potency = (@potency - rate.abs).clamp(0.0, 1.0).round(10)
            self
          end

          def catalyze!(multiplier: Constants::CATALYST_MULTIPLIER)
            boost = Constants::TRANSMUTATION_RATE * multiplier
            @purity = (@purity + boost).clamp(0.0, 1.0).round(10)
            @potency = (@potency + (boost * 0.5)).clamp(0.0, 1.0).round(10)
            @transmutation_count += 1
            self
          end

          def prima_materia?
            @stage == :nigredo && @purity < 0.2
          end

          def gold?
            @stage == :rubedo && @purity >= 0.8
          end

          def inert?
            @potency < 0.1
          end

          def purity_label
            Constants.label_for(Constants::PURITY_LABELS, @purity)
          end

          def potency_label
            Constants.label_for(Constants::POTENCY_LABELS, @potency)
          end

          def stage_label
            Constants::STAGE_LABELS.fetch(@stage, 'unknown')
          end

          def to_h
            {
              id:                  @id,
              element_type:        @element_type,
              domain:              @domain,
              content:             @content,
              stage:               @stage,
              stage_label:         stage_label,
              purity:              @purity,
              purity_label:        purity_label,
              potency:             @potency,
              potency_label:       potency_label,
              transmutation_count: @transmutation_count,
              discovered_at:       @discovered_at,
              prima_materia:       prima_materia?,
              gold:                gold?,
              inert:               inert?
            }
          end

          private

          def assign_core(element_type, domain, content)
            @id           = SecureRandom.uuid
            @element_type = element_type.to_sym
            @domain       = domain.to_sym
            @content      = content.to_s
          end

          def assign_metadata(purity, potency)
            @stage               = :nigredo
            @purity              = (purity || 0.1).to_f.clamp(0.0, 1.0).round(10)
            @potency             = (potency || 0.5).to_f.clamp(0.0, 1.0).round(10)
            @transmutation_count = 0
            @discovered_at       = Time.now.utc
          end

          def validate_type!(val)
            return if Constants::ELEMENT_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown element type: #{val.inspect}; " \
                  "must be one of #{Constants::ELEMENT_TYPES.inspect}"
          end
        end
      end
    end
  end
end
