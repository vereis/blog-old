defmodule Blog.Posts do
  @moduledoc """
  Context module for manipulating and querying data related to Blog Posts.
  """

  import Blog.Utils

  alias Blog.Posts.Post
  alias Blog.Repo

  @spec create_post(attrs :: map()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def create_post(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: [:slug])
  end

  @spec get_post!(filters :: Keyword.t()) :: Post.t()
  def get_post!(filters), do: filters |> get_post() |> then(fn {:ok, result} -> result end)

  @spec get_post(filters :: Keyword.t()) :: {:ok, Post.t()} | {:error, term()}
  def get_post(filters \\ []) do
    filters
    |> Keyword.put(:limit, 1)
    |> Post.query()
    |> Repo.one()
    |> return_ok()
  end

  @spec list_posts!(filters :: Keyword.t()) :: [Post.t()]
  def list_posts!(filters \\ []),
    do: filters |> list_posts() |> then(fn {:ok, result} -> result end)

  @spec list_posts(filters :: Keyword.t()) :: {:ok, [Post.t()]}
  def list_posts(filters \\ []) do
    filters
    |> Post.query()
    |> Repo.all()
    |> return_ok()
  end
end
