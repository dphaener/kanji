[![Gem Version](https://badge.fury.io/rb/kanji-web.svg)](https://badge.fury.io/rb/kanji-web)
[![Code Climate](https://codeclimate.com/github/dphaener/kanji/badges/gpa.svg)](https://codeclimate.com/github/dphaener/kanji)

# Kanji

## Overview

### A micro, GraphQL based, strongly typed, API only web framework

Kanji is based on a type system. The overall application architecture is
heavily inspired by [dry-web-roda](https://github.com/dry-rb/dry-web-roda).
Everything in the application is [container based](https://github.com/dry-rb/dry-container),
and the GraphQL API is inferred by creating types.

Currently Kanji supports only a Postgres database, so if you don't have Postgres
installed get to it and let's get started!

## Getting Started

### Install the gem

```bash
$ gem install kanji-web
```

This will install a global executable `kanji`. Let's start a new project:

```bash
$ kanji new todo
```

This will create a bunch of files in a folder called `todo`. It's a good start,
but the application really won't be usable until you create your first type
and add it to your GraphQL schema, so let's create our first type:

```bash
$ kanji g type User email:string name:string
```

This will generate a database migration, a new type, and a
repository(did I mention Kanji uses ROM?) to be used for accessing your data.

This also adds the mutations for the user to you root mutation type located
at: `app/mutation_type.rb`.

Next ensure that the database is created, and run the migration:

```bash
$ rake db:create && rake db:migrate
```

Great, now you have a `users` table in your database!

Next we're going to want to add a field to our base query type. Open up your
query definition at `app/query_type.rb` and add the following.

```rb
field :users do
  type -> { types[Types::User[:graphql_type]] }
  description "All of the users in this app"

  resolve -> (obj, args, ctx) { Types::User[:repo].all }
end
```

Next you'll want to open up your main schema file and uncomment the query and
mutation type declarations. This file is at `app/schema.rb`.

That's it! You now have a GraphQL API with a root node that you can
query and the basic `create`, `update`, and `destroy` mutations.

Let's start the server and play with the API:

```bash
$ kanji s
```

This will start a server on `localhost:9393`. Visit `localhost:9393/graphiql`
and play around with the API!

## Types

Types are the foundation for everything that is done in Kanji. When you create
a type and define it's attributes a lot of stuff happens under the covers.
Because everything is container based, when you create a type it is a container
and it exposes a few things that you can use in the application.

### value_object

An instance of this is returned when you fetch a row or rows from the database. It is
an immutable value object that does nothing but store the values and give you
accessors. It can be resolved from the container like so:
```ruby
Types::User[:value_object]
```
This object is typically not needed in regular development. It is used by the
repository to resolve database values.

### graphql_type

This is the graphql definition that is used in your graphql schemas. You can
see from above that we used it when defining our root `users` field.

### schema

This is a dry-validation schema that can be used to validate and manipulate
incoming data before persisting to the database.

### repo

This is the repository that is associated with the type. The definition lives
in the `app/repositories` folder, and is generated when you use the command
line type generator. It allows you to read/mutate data in the database.

## Repositories

Your repositories are what defines how you interact with data in the database.
All repositories inherit from `Kanji::Repository` and give you a few default
convenience methods: `create`, `update`, `destroy`, and `all`.

Beyond this, it is up to you to add methods that fetch/persist data as needed
by your application domain. The `Kanji::Repository` class exposes the `relation`
method that can be used to interact with the database. I.E. -

```ruby
module Repositories
  class Users < Kanji::Repository[:users]
    def find_by_id(id)
      relation.where(id: id).one
    end
  end
end
```

### create

The create method takes a params hash of all required attributes and creates
a new row in the database, returning an instance of the value_object for that
type.

### update

Similar to the create method, but also requires the primary key.

### destroy

Takes the primary key as the only argument and returns the same object that
was deleted from the database.

### all

Returns all of the records for this table.

### relation

A convenience method that allows you to run queries on the table for this particular
type.
