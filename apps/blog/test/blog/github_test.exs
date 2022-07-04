defmodule Blog.GitHubTest do
  use ExUnit.Case
  import Tesla.Mock

  alias Blog.GitHub

  @viewer_query """
  query {
    viewer {
      login
    }
  }
  """

  for function <- [:query, :mutation] do
    describe "#{function}/2" do
      test "returns value when GraphQL request succeeds" do
        mock(fn _request ->
          json(%{"data" => %{"viewer" => %{"login" => "vereis"}}}, status: 200)
        end)

        assert {:ok, %{"data" => %{"viewer" => %{"login" => "vereis"}}}} =
                 GitHub.unquote(function)(@viewer_query)
      end

      test "returns graphql error when GraphQL request fails" do
        mock(fn _request -> json(%{"errors" => ["error returned by GH"]}, status: 200) end)

        assert {:error, %{"errors" => ["error returned by GH"]}} =
                 GitHub.unquote(function)(@viewer_query)
      end

      test "returns tesla error when HTTP client fails" do
        mock(fn _request -> json(%{"error" => "whatever"}, status: 500) end)
        assert {:error, %Tesla.Env{status: 500}} = GitHub.unquote(function)(@viewer_query)
      end
    end
  end
end
