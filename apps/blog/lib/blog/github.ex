defmodule Blog.GitHub do
  @moduledoc """
  Simple Tesla wrapper over GitHub's GraphQL API.

  Returns `{:ok, response :: map()}` when query/mutation is valid, otherwise returns:

    - `{:error, Tesla.Env.t()}` if the query did not return a `200`
    - `{:error, reason :: map()}` if GitHub's GraphQL API returned an error

  Requires the environment variable "GITHUB_REPO_ACCESS_TOKEN" to be set.
  """

  use Tesla
  import Blog.Utils

  alias Blog.Config

  @type graphql_query :: String.t()

  plug(Tesla.Middleware.BaseUrl, "https://api.github.com/graphql")
  plug(Tesla.Middleware.Headers, [{"authorization", "Bearer " <> Config.access_token!()}])
  plug(Tesla.Middleware.JSON)

  @spec query(graphql_query(), variables :: map()) :: {:ok, map()} | {:error, map()}
  def query(query, variables \\ %{}) when is_binary(query), do: do_request(query, variables)

  @spec mutation(graphql_query(), variables :: map()) :: {:ok, map()} | {:error, map()}
  def mutation(query, variables \\ %{}) when is_binary(query), do: do_request(query, variables)

  defp do_request(query, variables) do
    case post("", %{query: query, variables: variables}) do
      {:ok, %Tesla.Env{status: 200} = payload} when not is_map_key(payload.body, "errors") ->
        {:ok, payload.body}

      {:ok, %Tesla.Env{status: 200} = payload} ->
        return_error(payload.body)

      error ->
        return_error(error)
    end
  end
end
