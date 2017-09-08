require "graphql"

class QueryType
  def call
    GraphQL::ObjectType.define do
      name "Query"
      description "The query root of this schema"

      field :users do
        type -> { types[Types::User[:graphql_type]] }
        resolve -> (obj, args, ctx) {
          Types::User[:repo].all
        }
      end
    end
  end
end
