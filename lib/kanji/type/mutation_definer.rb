require "kanji/instance_define"
require "kanji/errors"
require "kanji/type/mutation"
require "kanji/type/argument"

module Kanji
  class Type
    class MutationDefiner
      extend Kanji::InstanceDefine

      instance_define :name, :return_type, :resolve

      def initialize(&block)
        @_arguments = []
        self.instance_eval &block

        raise(AttributeError, "You must supply a name") unless @_name
        raise(AttributeError, "You must supply a return type") unless @_return_type
        raise(AttributeError, "You must supply a resolve proc") unless @_resolve
        raise(AttributeError, "You must supply at least one argument") if @_arguments.empty?
      end

      def argument(name, type, **kwargs)
        raise ArgumentError if @_arguments.map(&:name).include?(name.to_s)

        @_arguments << Argument.new({
          name: name.to_s,
          type: type,
          options: kwargs
        })
      end

      def call
        Mutation.new({
          name: @_name,
          return_type: @_return_type,
          arguments: @_arguments,
          resolve: @_resolve
        })
      end
    end
  end
end
