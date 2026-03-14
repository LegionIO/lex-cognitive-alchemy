# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_alchemy/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-alchemy'
  spec.version       = Legion::Extensions::CognitiveAlchemy::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = 'Cognitive alchemy LEX — transmutation of ideas through alchemical stages'
  spec.description   = 'Models the Magnum Opus of idea transmutation: substances pass through ' \
                        'nigredo/albedo/citrinitas/rubedo stages, crucible reactions combine elements ' \
                        'under heat and pressure, and philosopher stone catalysis accelerates breakthroughs.'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-alchemy'

  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = spec.homepage
  spec.metadata['documentation_uri'] = "#{spec.homepage}#readme"
  spec.metadata['changelog_uri']     = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']   = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']
end
