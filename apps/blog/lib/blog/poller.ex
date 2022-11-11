defmodule Blog.Poller do
  @moduledoc """
  Module which houses business logic which pages through GitHub's API, fetching all the
  GitHub Issues for the given repository, and tries to upsert them into the database.
  """

  import Blog.Utils

  alias Blog.Config
  alias Blog.GitHub
  alias Blog.Posts

  @query """
  query($owner: String!, $repo: String!, $count: Int!, $filters: IssueFilters!, $sort: IssueOrder!, $cursor: String) {
    repository(owner: $owner, name: $repo) {
      issues(first: $count, filterBy: $filters, orderBy: $sort, after: $cursor) {
        nodes {
          id: number
          content: bodyHTML
          markdown: body
          created_at: createdAt
          updated_at: updatedAt
          title
          tags: labels(first: $count) {
            nodes {
              name
            }
          }
        }
        totalCount
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  }
  """

  @doc """
  Iterates over the configured repository's GitHub Issues until no issues remain, and
  tries to insert them into the database.

  Returns a count of inserts which were successful, as well as a list of errors, if any.
  """
  @spec execute :: {:ok, insert_count: integer(), errors: [Ecto.Changeset.t()]}
  def execute do
    callback = fn -> fn cursor -> GitHub.query(@query, build_params(cursor)) end end
    initial_cursor = nil

    {successes, errors} =
      callback
      |> Stream.repeatedly()
      |> Stream.transform(initial_cursor, fn fetch_chunk, cursor ->
        {:ok, data} = fetch_chunk.(cursor)

        posts =
          data
          |> get_in(["data", "repository", "issues", "nodes"])
          |> Enum.map(fn post ->
            tags = get_in(post, ["tags", "nodes"]) || []
            %{post | "tags" => Enum.map(tags, &Map.get(&1, "name"))}
          end)

        cursor = get_in(data, ["data", "repository", "issues", "pageInfo", "endCursor"])
        has_next_page? = get_in(data, ["data", "repository", "issues", "pageInfo", "hasNextPage"])

        if posts == [] && !has_next_page?, do: {:halt, cursor}, else: {posts, cursor}
      end)
      |> Stream.map(&build_attrs/1)
      |> Stream.map(&Posts.create_post/1)
      |> Enum.split_with(&ok?/1)

    {:ok, insert_count: length(successes), errors: Enum.map(errors, &elem(&1, 1))}
  end

  defp build_params(cursor) do
    owner = owner()
    repo = repo()

    %{
      count: 5,
      owner: owner,
      repo: repo,
      filters: %{createdBy: owner},
      sort: %{field: "CREATED_AT", direction: "DESC"},
      cursor: cursor
    }
  end

  defp owner, do: Config.repo!() |> String.split("/") |> List.first()
  defp repo, do: Config.repo!() |> String.split("/") |> List.last()

  defp build_attrs(post) do
    post
    |> Map.update("content", "", &Regex.replace(~r/href="#/, &1, "href=\"/posts_by_id/"))
  end
end
