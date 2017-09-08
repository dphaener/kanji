require "graphql"

class MutationType
  def call
    GraphQL::ObjectType.define do
      name "MutationType"
      description "The mutation root of this schema"

      field :createUser, Types::User[:create_mutation]
      field :updateUser, Types::User[:update_mutation]
      field :destroyUser, Types::User[:destroy_mutation]
    end
  end
end
