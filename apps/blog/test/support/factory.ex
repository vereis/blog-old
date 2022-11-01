defmodule Blog.Factory do
  use ExMachina.Ecto, repo: Blog.Repo

  alias Blog.Posts.Post

  def post_factory do
    %Post{}
  end
end
