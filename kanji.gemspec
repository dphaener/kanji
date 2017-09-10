lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "kanji/version"

Gem::Specification.new do |s|
  s.name              = "kanji-web"
  s.version           = Kanji::Version
  s.summary           = "A strongly Typed GraphQL API"
  s.authors           = ["Darin Haener"]
  s.email             = ["dphaener@gmail.com"]
  s.homepage          = "https://github.com/dphaener/kanji"
  s.license           = "MIT"
  s.executables       = ["kanji"]
  s.required_ruby_version = ">= 2.0.0"

  s.files = %w"LICENSE Rakefile" + Dir["lib/**/{*,.?*}"] + Dir["bin/*"]

  s.add_dependency "dry-auto_inject", "~> 0.4"
  s.add_dependency "dry-container", "~> 0.6"
  s.add_dependency "dry-core", "~> 0.3"
  s.add_dependency "dry-monads", "~> 0.3"
  s.add_dependency "dry-struct", "~> 0.3"
  s.add_dependency "dry-system", "~> 0.7"
  s.add_dependency "dry-transaction", "~> 0.10"
  s.add_dependency "dry-types", "~> 0.11"
  s.add_dependency "dry-validation", "~> 0.11"
  s.add_dependency "dry-web", "~> 0.7"
  s.add_dependency "graphql", "~> 1.5"
  s.add_dependency "pry", "~> 0.10"
  s.add_dependency "rake", "~> 12.0"
  s.add_dependency "roda", "~> 2.29"
  s.add_dependency "roda-flow", "~> 0.3"
  s.add_dependency "rom", "~> 3.1"
  s.add_dependency "rom-repository", "~> 1.4"
  s.add_dependency "rom-sql", "~> 1.3"
  s.add_dependency "shotgun", "~> 0.9"
  s.add_dependency "thin", "~> 1.7"
  s.add_dependency "thor", "~> 0.19"
  s.add_dependency "tilt", "~> 2.0"
  s.add_dependency "transproc", "~> 1.0"

  s.add_development_dependency "bundler", "~> 1.15"
  s.add_development_dependency "byebug", "~> 9.0"
  s.add_development_dependency "coveralls", "~> 0.8"
  s.add_development_dependency "pry-byebug", "~> 3.4"
  s.add_development_dependency "rainbow", "~> 2.2"
  s.add_development_dependency "rspec", "~> 3.6"
  s.add_development_dependency "rspec-graphql_matchers", "~> 0.5"
  s.add_development_dependency "rubocop", "~> 0.45"
  s.add_development_dependency "simplecov", "~> 0.9"
end
