# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveAlchemy
      module Helpers
        class Crucible
          attr_reader :id, :reaction_type, :input_ids, :output_id,
                      :heat, :pressure, :started_at, :completed_at

          def initialize(reaction_type:, input_ids:,
                         heat: 0.5, pressure: 0.5)
            validate_reaction!(reaction_type)
            @id            = SecureRandom.uuid
            @reaction_type = reaction_type.to_sym
            @input_ids     = Array(input_ids).dup
            @output_id     = nil
            @heat          = heat.to_f.clamp(0.0, 1.0).round(10)
            @pressure      = pressure.to_f.clamp(0.0, 1.0).round(10)
            @started_at    = Time.now.utc
            @completed_at  = nil
          end

          def complete!(output_id)
            @output_id    = output_id
            @completed_at = Time.now.utc
            self
          end

          def completed?
            !@completed_at.nil?
          end

          def intensity
            ((@heat + @pressure) / 2.0).round(10)
          end

          def volatile?
            @heat > 0.8 && @pressure > 0.8
          end

          def mild?
            intensity < 0.3
          end

          def to_h
            {
              id:            @id,
              reaction_type: @reaction_type,
              input_ids:     @input_ids,
              output_id:     @output_id,
              heat:          @heat,
              pressure:      @pressure,
              intensity:     intensity,
              volatile:      volatile?,
              mild:          mild?,
              started_at:    @started_at,
              completed_at:  @completed_at,
              completed:     completed?
            }
          end

          private

          def validate_reaction!(val)
            return if Constants::REACTION_TYPES.include?(val.to_sym)

            raise ArgumentError,
                  "unknown reaction type: #{val.inspect}; " \
                  "must be one of #{Constants::REACTION_TYPES.inspect}"
          end
        end
      end
    end
  end
end
