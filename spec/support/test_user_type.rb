module Types
  class TestUser < Kanji::Type
    name "TestUser"
    description "A test user"

    attribute :email, Kanji::Types::String, "The test email", required: true
    attribute :name do
      type Kanji::Types::String.optional
      description "The test name"
    end

    assoc :posts, Kanji::Types::Array.member(TestPost).default([]), "All of the posts for the user"

    register :repo, Repositories::TestUsers

    create do |object, context, arguments|
      puts "Foo"
    end

    update do |object, context, arguments|
      puts "Foo"
    end

    destroy do |object, context, arguments|
      puts "Foo"
    end
  end
end
