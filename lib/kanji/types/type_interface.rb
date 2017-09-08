require "dry-types"

module Kanji
  module Types
    module TypeInterface
      def try(obj, &block)
        result = valid?(obj) ? success(obj) : failure(obj, constraint_error(obj))

        return result if result.success?

        if block
          yield(result)
        else
          result
        end
      end

      def success(obj)
        Dry::Types::Result::Success.new(obj)
      end

      def failure(obj, error)
        Dry::Types::Result::Failure.new(obj, error)
      end

      def |(other)
        Dry::Types::Sum::Constrained.new(self, other)
      end

      def optional
        Dry::Types::Sum.new(Kanji::Types::Nil, self)
      end

      def constrained?
        true
      end

      def valid?
        raise NotImplementedError, "You must implement the valid? method"
      end
    end
  end
end
