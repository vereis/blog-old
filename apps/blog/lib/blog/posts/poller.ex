defmodule Blog.Posts.Poller do
  use Task

  # 5 minutes
  @timeout 5000 * 60

  @chunk_size 5

  def owner, do: Application.get_env(:blog, :owner)
  def name, do: Application.get_env(:blog, :repo)

  alias Blog.GraphQL
  alias Blog.Posts
  alias Blog.Posts.Post

  def start_link(_args) do
    Task.start_link(&task/0)
  end

  def task() do
    fetch_posts()
    Process.sleep(@timeout)
    task()
  end

  def fetch_posts(cursor \\ nil) do
    """
    query($owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
        issues(#{list_chunk_opts(cursor)}) {
          nodes {
            id: number
            content: bodyHTML
            raw_content: body
            created_at: createdAt
            updated_at: updatedAt
            title
            tags: labels(first: 10) {
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
    |> GraphQL.query(%{owner: owner(), name: name()})
    |> case do
      {:ok, response} ->
        process_response(response)

      error ->
        error
    end
  end

  defp list_chunk_opts(nil) do
    "filterBy: {createdBy: $owner}, first: #{@chunk_size}, orderBy: {field: CREATED_AT, direction: DESC}"
  end

  defp list_chunk_opts(cursor) do
    "filterBy: {createdBy: $owner}, first: #{@chunk_size}, after: \"#{cursor}\", orderBy: {field: CREATED_AT, direction: DESC}"
  end

  defp process_response(response) do
    %{
      "nodes" => nodes,
      "pageInfo" => %{"hasNextPage" => has_next_page?, "endCursor" => end_cursor}
    } = response |> get_in(["data", "repository", "issues"])

    for %{"tags" => %{"nodes" => tags}} = node <- nodes do
      node = %{node | "tags" => Enum.map(tags, & &1["name"])}

      case Blog.Posts.create_post(node) do
        {:ok, %Post{} = blog_post} ->
          {:ok, blog_post}

        {:error, %Ecto.Changeset{action: :insert, valid?: false, changes: data}} ->
          {:ok, %Post{} = post} = Posts.get_post(data.id)
          Posts.update_post(post, node)
      end
    end

    if has_next_page? do
      fetch_posts(end_cursor)
    else
      :ok
    end
  end
end
