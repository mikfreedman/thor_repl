
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "thor_repl/version"

Gem::Specification.new do |spec|
  spec.name          = "thor_repl"
  spec.version       = ThorRepl::VERSION
  spec.authors       = ["Mik Freedman"]
  spec.email         = ["github@michael-freedman.com"]

  spec.summary       = "Create a REPL for any Thor CLI"
  spec.homepage      = "https://github.com/mikfreedman/thor_repl"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter"
end
