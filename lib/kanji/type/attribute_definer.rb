require "kanji/type/attribute"
require "kanji/instance_define"
require "kanji/errors"

module Kanji
  class Type
    class AttributeDefiner
      extend Kanji::InstanceDefine

      instance_define :type, :description, :options, :resolve

      def initialize(name, type = nil, description = nil, **kwargs, &block)
        @_name = name
        @_type = type
        @_description = description
        @_options = kwargs
        self.instance_eval &block if block_given?

        raise AttributeError unless @_type
      end

      def call
        Attribute.new({
          name: @_name,
          type: @_type,
          description: @_description,
          options: @_options,
          resolve: @_resolve
        })
      end
    end
  end
end
