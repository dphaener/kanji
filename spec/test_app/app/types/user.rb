require "kanji/type"

module Types
  class User < Kanji::Type
    name "User"
    description "A user"

    attribute :email, Kanji::Types::String, "The users email"
    attribute :name, Kanji::Types::String, "The users name"

    assoc :todo_lists do
      type Kanji::Types::Array.member(TodoList).default([])
      description "The users todo lists"
      resolve -> (user, args, ctx) {
        user.resolve(:repo).todo_lists_for(user.id).to_a
      }
    end

    register :repo, TestApp::Container["repos.users"]

    create do |_, args, _|
      resolve(:repo).create(args.to_h)
    end

    update do |_, args, _|
      resolve(:repo).update(args.to_h)
    end

    destroy do |_, args, _|
      resolve(:repo).destroy(args[:id])
    end
  end
end
