require "dry/web/settings"
require "kanji/types"

module TestApp
  class Settings < Dry::Web::Settings
    setting :database_url, Kanji::Types::Strict::String.constrained(filled: true)
    setting :env, Kanji::Types::Strict::String.default("development")
  end
end
