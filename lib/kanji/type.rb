require "dry-container"
require "kanji/types"
require "kanji/type/class_interface"
require "kanji/errors"

module Kanji
  class Type
    extend Dry::Container::Mixin
    extend ClassInterface

    include Dry::Container::Mixin

    def initialize(params)
      result = self.class.resolve(:schema).call(params)

      if result.success?
        register :value, -> { self.class.resolve(:value_object).new(params) }
      else
        errors = parse_error_messages(result)
        raise ValidationError, "Schema validation failed - #{errors}"
      end

      self.class.instance_variable_get(:@_values).each do |key, value|
        register key.to_sym, value
      end

      if repo = self.class.resolve(:repo)
        register :repo, repo
      end
    end

    def to_h
      resolve(:value).to_h
    end

    def to_json
      to_h.to_json
    end

    def method_missing(method_name, *args, &block)
      if resolve(:value).respond_to?(method_name)
        resolve(:value).send(method_name, *args)
      else
        super(method_name, *args, &block)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      if resolve(:value).respond_to?(method_name)
        true
      else
        super(method_name, include_private)
      end
    end

    private

    def parse_error_messages(result)
      result.messages(full: true).values.flatten.join(",")
    end
  end
end
