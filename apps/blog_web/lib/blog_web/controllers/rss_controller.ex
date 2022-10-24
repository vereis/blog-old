defmodule BlogWeb.RssController do
  use BlogWeb, :controller
  plug(:put_root_layout, false)

  alias Blog.Posts

  def index(conn, _params) do
    with {:ok, posts} <- Posts.list_posts() do
      conn
      |> assign(:posts, posts)
      |> render("index.xml")
    end
  end
end
