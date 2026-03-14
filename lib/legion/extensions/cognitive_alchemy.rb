# frozen_string_literal: true

require 'securerandom'

require_relative 'cognitive_alchemy/version'
require_relative 'cognitive_alchemy/helpers/constants'
require_relative 'cognitive_alchemy/helpers/substance'
require_relative 'cognitive_alchemy/helpers/crucible'
require_relative 'cognitive_alchemy/helpers/alchemy_engine'
require_relative 'cognitive_alchemy/runners/cognitive_alchemy'
require_relative 'cognitive_alchemy/client'

module Legion
  module Extensions
    module CognitiveAlchemy
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
