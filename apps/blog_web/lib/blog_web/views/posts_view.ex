defmodule BlogWeb.PostsView do
  use BlogWeb, :view

  def list_view_title(nil, _posts) do
    "All Posts"
  end

  def list_view_title(_label, []) do
    "Oops! There isn't anything here."
  end

  def list_view_title(label, posts) do
    # De-downcase the labels which come in through
    # URLs by finding the equivalent label in
    # all posts being shown.
    known_labels =
      posts
      |> Enum.flat_map(& &1.tags)
      |> Enum.uniq()
      |> Map.new(&{String.downcase(&1), &1})

    case known_labels[label] do
      nil -> "Oops! There isn't anything here."
      label -> "All Posts tagged `#{label}`"
    end
  end
end
