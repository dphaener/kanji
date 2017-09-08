require "kanji/generate"
require "dry/core/inflector"

module Kanji
  module Generators
    class AbstractGenerator
      def initialize(target_dir)
        @target_dir = target_dir
        @templates = []
        populate_templates
        @templates.freeze
      end

      def call
        templates.each do |source, target|
          generator.(source, target)
        end

        post_process_callback
      end

      private
      attr_reader :target_dir, :templates

      def populate_templates
        fail NotImplementedError
      end

      def post_process_callback

      end

      def add_template(source, target)
        templates << [source, target]
      end

      def generator
        @generator ||= Generate.new(destination, template_scope)
      end

      def destination
        fail NotImplementedError
      end

      def template_scope
        fail NotImplementedError
      end
    end
  end
end
