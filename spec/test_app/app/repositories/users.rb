require "kanji/repository"

module Repositories
  class Users < Kanji::Repository[:users]
    def todo_lists_for(id)
      users.todo_lists.where(user_id: id)
    end

    def find_by_id(id)
      users.where(id: id).one
    end
  end
end
