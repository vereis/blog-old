defmodule BlogApi.Router do
  use BlogApi, :router

  forward "/graphql", Absinthe.Plug, schema: BlogApi.GraphQL.Schema
  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BlogApi.GraphQL.Schema
end
