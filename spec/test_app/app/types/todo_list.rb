require "kanji/type"

module Types
  class TodoList < Kanji::Type
    name "TodoList"
    description "A todo list"

    attribute :title, Kanji::Types::String, "The title of this todo list"
    attribute :description, Kanji::Types::String, "The description of this todo list"
    attribute :user_id, Kanji::Types::Int, "The user_id foreign key"

    register :repo, TestApp::Container["repos.todo_lists"]

    create do |object, arguments, context|
      resolve(:repo).create(arguments.to_h)
    end

    update do |object, arguments, context|
      resolve(:repo).update(arguments.to_h)
    end

    destroy do |object, arguments, context|
      resolve(:repo).destroy(arguments[:id])
    end
  end
end
