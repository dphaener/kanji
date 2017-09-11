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

      field :user do
        type -> { Types::User[:graphql_type] }

        argument :id, types.ID

        resolve -> (obj, args, ctx) {
          Types::User[:repo].find_by_id(args[:id])
        }
      end
    end
  end
end
