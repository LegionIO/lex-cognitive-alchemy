# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveAlchemy
      module Helpers
        module Constants
          # Alchemical stages (Magnum Opus)
          STAGES = %i[nigredo albedo citrinitas rubedo].freeze

          # Transmutation element types
          ELEMENT_TYPES = %i[
            concept belief skill memory emotion
            pattern habit intuition hypothesis
          ].freeze

          # Crucible reaction types
          REACTION_TYPES = %i[
            calcination dissolution separation conjunction
            fermentation distillation coagulation
          ].freeze

          # Maximum substances in the athanor
          MAX_SUBSTANCES = 200

          # Maximum crucible reactions
          MAX_REACTIONS = 100

          # Base transmutation rate per stage advance
          TRANSMUTATION_RATE = 0.15

          # Decay rate for unreacted substances
          SUBSTANCE_DECAY = 0.02

          # Philosopher's stone catalyst multiplier
          CATALYST_MULTIPLIER = 3.0

          # Stage labels
          STAGE_LABELS = {
            nigredo:    'Blackening — decomposition of raw material',
            albedo:     'Whitening — purification and washing',
            citrinitas: 'Yellowing — solar awakening',
            rubedo:     'Reddening — final integration and gold'
          }.freeze

          # Purity labels (range-based)
          PURITY_LABELS = [
            [(0.8..),      :aurum],
            [(0.6...0.8),  :argentum],
            [(0.4...0.6),  :cuprum],
            [(0.2...0.4),  :ferrum],
            [(..0.2),      :plumbum]
          ].freeze

          # Potency labels
          POTENCY_LABELS = [
            [(0.8..),      :transcendent],
            [(0.6...0.8),  :potent],
            [(0.4...0.6),  :moderate],
            [(0.2...0.4),  :weak],
            [(..0.2),      :inert]
          ].freeze

          def self.label_for(table, value)
            table.each { |range, label| return label if range.cover?(value) }
            table.last.last
          end
        end
      end
    end
  end
end
