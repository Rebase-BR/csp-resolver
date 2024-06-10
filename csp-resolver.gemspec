# frozen_string_literal: true

require_relative 'lib/csp/version'

Gem::Specification.new do |spec|
  spec.name = 'csp-resolver'
  spec.version = CSP::VERSION
  spec.license = 'MIT'
  spec.authors = ['André Benjamim', 'Gustavo Alberto']
  spec.email = ['andre.benjamim@rebase.com.br', 'gustavo.costa@rebase.com.br']

  spec.summary = 'A Ruby CSP Solver'
  spec.description = 'This Ruby gem solves CSPs using custom constraints'
  spec.homepage = 'https://github.com/Rebase-BR/csp-resolver'
  spec.required_ruby_version = '>= 2.5.8'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Rebase-BR/csp-resolver'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
