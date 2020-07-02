defmodule Blog.Posts do
  alias Blog.Repo
  alias Blog.Posts.Post

  @spec get_post(id :: number()) :: {:ok, Post.t()} | {:error, term()}
  def get_post(id) do
    Post
    |> Repo.get(id)
    |> case do
      %Post{} = blog_post ->
        {:ok, blog_post}

      nil ->
        {:error, :not_found}
    end
  end

  @spec get_post_by_title(title :: String.t()) :: {:ok, Post.t()} | {:error, term()}
  def get_post_by_title(title) when is_binary(title) do
    Post
    |> Repo.get_by(normalized_title: title)
    |> case do
      %Post{} = blog_post ->
        {:ok, blog_post}

      nil ->
        {:error, :not_found}
    end
  end

  @spec create_post(params :: map()) :: {:ok, Post.t()} | {:error, term()}
  def create_post(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert()
  end

  @spec update_post(post :: Blot.Post.t(), params :: map()) :: {:ok, Post.t()} | {:error, term()}
  def update_post(%Post{} = blog_post, params) do
    blog_post
    |> Post.changeset(params)
    |> Repo.update()
  end

  @spec list_posts() :: {:ok, [Post.t()]}
  def list_posts() do
    posts =
      Post
      |> Repo.all()
      |> Enum.sort_by(& &1.created_at, {:desc, DateTime})

    {:ok, posts}
  end

  def list_posts_with_tag(tag) do
    with {:ok, posts} <- list_posts() do
      # Manual filtering because Etso doesn't support the neccessary actions
      filtered_posts =
        posts
        |> Enum.filter(fn post ->
          String.downcase(tag) in Enum.map(post.tags, &String.downcase/1)
        end)

      {:ok, filtered_posts}
    end
  end
end
