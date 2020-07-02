defmodule BlogWeb.PostsController do
  use BlogWeb, :controller

  alias Blog.Posts
  alias Blog.Posts.Post

  def index(conn, %{"tag" => tag}) do
    with {:ok, posts} <- Posts.list_posts_with_tag(tag) do
      conn
      |> assign(:posts, posts)
      |> assign(:tag, tag)
      |> render("index.html")
    end
  end

  def index(conn, _params) do
    with {:ok, posts} <- Posts.list_posts() do
      conn
      |> assign(:posts, posts)
      |> assign(:tag, nil)
      |> render("index.html")
    end
  end

  def show(conn, %{"title" => title}) do
    with {:ok, %Post{} = post} <- Posts.get_post_by_title(title) do
      conn
      |> assign(:post, post)
      |> assign(:show_list_button, true)
      |> render("show.html")
    end
  end

  def home(conn, _params) do
    with {:ok, %Post{} = post} <- Posts.get_post(1) do
      conn
      |> assign(:post, post)
      |> assign(:show_list_button, false)
      |> render("show.html")
    end
  end
end
