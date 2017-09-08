require "dry-types"
require_relative "./type_interface"

module Kanji
  module Types
    class Callable
      extend TypeInterface

      class << self
        def call(obj)
          raise constraint_error(obj) unless valid?(obj)
          obj
        end

        def valid?(obj)
          obj.respond_to?(:call)
        end

        private

        def constraint_error(obj)
          Dry::Types::ConstraintError.new(
            "Object must respond to the call method",
            obj
          )
        end
      end
    end
  end
end
