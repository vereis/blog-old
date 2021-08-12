defmodule Blog.Posts do
  @moduledoc """
  Top level context for posts
  """

  alias Blog.Posts.{InternalLinks, Post}
  alias Blog.Repo

  @spec get_post_by_id(id :: number()) :: {:ok, %Post{}} | {:error, term()}
  def get_post_by_id(id) do
    Post
    |> Post.where_id(id)
    |> Repo.one()
    |> case do
      %Post{} = post ->
        {:ok, post}

      nil ->
        {:error, :not_found}
    end
  end

  @spec get_post_by_title(title :: String.t()) :: {:ok, %Post{}} | {:error, term()}
  def get_post_by_title(title) when is_binary(title) do
    Post
    |> Post.where_normalized_title(title)
    |> Repo.one()
    |> case do
      %Post{} = post ->
        {:ok, post}

      nil ->
        {:error, :not_found}
    end
  end

  @spec create_post(params :: map()) :: {:ok, %Post{}} | {:error, term()}
  def create_post(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert()
  end

  @spec update_post(post :: %Post{}, params :: map()) :: {:ok, %Post{}} | {:error, term()}
  def update_post(%Post{} = post, params) do
    post
    |> Post.changeset(params)
    |> Repo.update()
  end

  @spec list_posts :: {:ok, [%Post{}]}
  def list_posts do
    posts =
      Post
      |> Post.where_not_is_draft()
      |> Repo.all()
      |> Enum.sort_by(& &1.created_at, {:desc, DateTime})

    {:ok, posts}
  end

  @spec list_posts_with_tag(tag :: String.t()) :: {:ok, [%Post{}]}
  def list_posts_with_tag(tag) do
    {:ok, posts} = list_posts()

    # No way to do this with just Etso
    filtered_posts =
      posts
      |> Enum.filter(fn post ->
        String.downcase(tag) in Enum.map(post.tags, &String.downcase/1)
      end)

    {:ok, filtered_posts}
  end

  @spec list_posts_where_id_in([id :: number()]) :: {:ok, [%Post{}]}
  def list_posts_where_id_in(ids) do
    posts =
      Post
      |> Post.where_id_in(ids)
      |> Repo.all()

    {:ok, posts}
  end

  @spec list_tags() :: {:ok, [String.t()]}
  def list_tags() do
    {:ok, posts} = list_posts()

    all_tags =
      posts
      |> Enum.flat_map(& &1.tags)
      |> Enum.uniq()

    {:ok, all_tags}
  end

  @spec process_internal_links(%Post{}) :: {:ok, %Post{}}
  def process_internal_links(%Post{} = post) do
    with {:ok, internal_links} <- InternalLinks.get_internal_links(post),
         {:ok, post} <- InternalLinks.hydrate_internal_links(post, internal_links) do
      {:ok, post}
    end
  end
end
