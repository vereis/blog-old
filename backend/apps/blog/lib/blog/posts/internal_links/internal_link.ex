defmodule Blog.Posts.InternalLink do
  @moduledoc """
  Type and struct definition of internal link representation
  """

  defstruct [:old_href, :new_href, :linked_post_id, :post]
end
