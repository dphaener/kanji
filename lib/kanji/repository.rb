require "rom-repository"
require "dry/core/inflector"

module Kanji
  class Repository < ROM::Repository::Root
    def klass
      @_klass ||= self.class
    end

    def relation_name
      @_relation_name ||= begin
        name = Dry::Core::Inflector.demodulize(klass.name)
        Dry::Core::Inflector.underscore(name)
      end
    end

    def type
      @_type ||= begin
        name = Dry::Core::Inflector.demodulize(klass.name)
        singular_name = Dry::Core::Inflector.singularize(name)
        Dry::Core::Inflector.constantize("Types::#{singular_name}")
      end
    end

    def relation
      @_relation ||= relations[relation_name].map_to(type)
    end

    def value_object
      @_value_object ||= type.resolve(:value_object)
    end

    def all
      relation.to_a
    end

    def create(params)
      pk = relation.insert(params)
      relation.where(id: pk).one
    end

    def update(params)
      relation.where(id: params["id"]).update(params)
      relation.where(id: params["id"]).one
    end

    def destroy(id)
      item = relation.where(id: id).one
      relation.where(id: id).delete
      item
    end
  end
end
