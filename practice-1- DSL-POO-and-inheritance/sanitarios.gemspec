# frozen_string_literal: true

require_relative "lib/sanitarios/version"

Gem::Specification.new do |spec|
  spec.name = "sanitarios"
  spec.version = Sanitarios::VERSION
  spec.authors = ["Adrian Martin"]
  spec.email = ["alu0101547619@ull.edu.es"]

  spec.summary = "DSL interno en Ruby para la organización y supervisión de servicios de salud."
  spec.description = "Sanitarios es una gema elaborada en Ruby que utiliza un lenguaje específico
   de dominio (DSL) interno para planear y controlar los servicios sanitarios, prestando particular
    atención a los servicios de asistencia quirúrgica. Posibilita la definición de quirófanos, 
    clasificaciones ISO y funcionales, personal médico y procedimientos quirúrgicos, lo que ayuda 
    a organizar y optimizar los recursos del hospital."
  spec.homepage = "https://github.com/ULL-ESIT-LPP-2526/07-dsl-adrian-martin-alu0101547619.git"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ULL-ESIT-LPP-2526/07-dsl-adrian-martin-alu0101547619.git"
  spec.metadata["changelog_uri"] = "https://github.com/ULL-ESIT-LPP-2526/07-dsl-adrian-martin-alu0101547619.git/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-rspec"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
