require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/lib/kanji/generate.rb"
  add_filter "/lib/kanji/cli.rb"
  add_filter "/lib/kanji/logger.rb"
  add_filter "/lib/kanji/version.rb"
end

require "pathname"
require "pry-byebug"
require "rspec/graphql_matchers"

ENV['RACK_ENV'] ||= 'test'

SPEC_ROOT = Pathname(__FILE__).dirname

require SPEC_ROOT.join("../lib/kanji")

Dir["./lib/kanji/graph/**/*.rb"].each(&method(:require))
Dir["./lib/kanji/type/**/*.rb"].each(&method(:require))
Dir["./lib/kanji/types/**/*.rb"].each(&method(:require))
Dir["./lib/kanji/*.rb"].reject do |file|
  file.match /cli|generate/
end.each(&method(:require))
Dir["./spec/support/**/*.rb"].each(&method(:require))

RSpec.configure do |config|
  #config.use_transactional_fixtures = false
  #config.infer_spec_type_from_file_location!
  #config.filter_run_excluding ignore: true
end
