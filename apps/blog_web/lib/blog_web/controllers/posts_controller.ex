defmodule BlogWeb.PostsController do
  use BlogWeb, :controller

  alias Blog.Posts
  alias Blog.Posts.Post

  def index(conn, %{"tag" => tag}) do
    with {:ok, posts} <- Posts.list_posts_with_tag(tag),
         {:ok, tags} <- Posts.list_tags() do
      conn
      |> assign(:posts, posts)
      |> assign(:tag, tag)
      |> assign(:tags, tags)
      |> render("index.html")
    end
  end

  def index(conn, _params) do
    with {:ok, posts} <- Posts.list_posts(),
         {:ok, tags} <- Posts.list_tags() do
      conn
      |> assign(:posts, posts)
      |> assign(:tag, nil)
      |> assign(:tags, tags)
      |> render("index.html")
    end
  end

  def show(conn, %{"title" => title}) do
    with {:ok, %Post{} = post} <- Posts.get_post_by_title(title),
         {:ok, %Post{} = post} <- Posts.process_internal_links(post) do
      conn
      |> assign(:post, post)
      |> assign(:show_list_button, true)
      |> render("show.html")
    end
  end

  def uses(conn, _params) do
    with {:ok, %Post{} = post} <- Posts.get_post_by_title("stuff_i_use"),
         {:ok, %Post{} = post} <- Posts.process_internal_links(post) do
      conn
      |> assign(:post, post)
      |> assign(:show_list_button, true)
      |> render("show.html")
    end
  end

  def home(conn, _params) do
    with {:ok, %Post{} = post} <- Posts.get_post_by_id(1),
         {:ok, %Post{} = post} <- Posts.process_internal_links(post) do
      conn
      |> assign(:post, post)
      |> assign(:show_list_button, false)
      |> render("show.html")
    end
  end
end
