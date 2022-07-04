defmodule Blog.Posts do
  @moduledoc """
  Context module for manipulating and querying data related to Blog Posts.
  """

  alias Blog.Posts.Post
  alias Blog.Repo

  @spec create_post(attrs :: map()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def create_post(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert(on_conflict: :replace_all, conflict_target: [:slug])
  end
end
