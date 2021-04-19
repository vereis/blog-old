defmodule BlogWeb.LayoutView do
  use BlogWeb, :view

  def page_title(%Plug.Conn{assigns: %{posts: _posts}}) do
    " · All Posts"
  end

  def page_title(%Plug.Conn{assigns: %{post: %{title: title}}}) do
    " · #{title}"
  end

  def page_title(_conn) do
    ""
  end
end
