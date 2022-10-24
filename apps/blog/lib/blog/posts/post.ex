defmodule Blog.Posts.Post do
  @moduledoc """
  Encapsulates re-usable Ecto queries and schema/changeset definitions for blog posts
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__

  @type t :: %Post{}

  @draft_prefixes ["Draft", "WIP"]
  @average_words_read_per_minute 238

  schema "posts" do
    field(:slug, :string)
    field(:title, :string)
    field(:content, :string)
    field(:markdown, :string)
    field(:reading_time_minutes, :integer)

    field(:created_at, :utc_datetime_usec)
    field(:updated_at, :utc_datetime_usec)

    field(:is_draft, :boolean, default: false)

    field(:tags, {:array, :string})
  end

  @spec changeset(Post.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:id, :title, :content, :created_at, :updated_at, :tags, :markdown])
    |> validate_required([:id, :title, :content, :created_at, :updated_at, :tags, :markdown])
    |> unique_constraint(:id, name: :posts_pkey)
    |> unique_constraint(:slug, name: :posts_slug_index)
    |> put_slug()
    |> put_is_draft()
    |> put_estimated_reading_time()
  end

  defp put_slug(%Ecto.Changeset{changes: %{title: title}} = changeset) do
    slug =
      ~r/[^((A-Za-z0-9)| )]/
      |> Regex.replace(title, "", capture: :all)
      |> String.downcase()
      |> String.replace_prefix("wip", "")
      |> String.replace_prefix("draft", "")
      |> String.trim(" ")
      |> String.replace(" ", "_")

    put_change(changeset, :slug, slug)
  end

  defp put_slug(%Ecto.Changeset{} = changeset) do
    changeset
  end

  defp put_is_draft(%Ecto.Changeset{changes: %{title: title}} = changeset) do
    put_change(changeset, :is_draft, Enum.any?(@draft_prefixes, &String.starts_with?(title, &1)))
  end

  defp put_is_draft(%Ecto.Changeset{} = changeset) do
    changeset
  end

  defp put_estimated_reading_time(%Ecto.Changeset{changes: %{markdown: markdown}} = changeset) do
    approximate_word_count =
      markdown
      |> String.split(~r/\s/)
      |> Enum.count(fn string -> Regex.match?(~r/[a-zA-Z]+/, string) end)

    put_change(
      changeset,
      :reading_time_minutes,
      ceil(approximate_word_count / @average_words_read_per_minute)
    )
  end

  defp put_estimated_reading_time(%Ecto.Changeset{} = changeset) do
    changeset
  end

  @spec base_query :: Ecto.Queryable.t()
  def base_query do
    Post
  end

  @spec query(Ecto.Queryable.t(), Keyword.t()) :: Ecto.Queryable.t()
  def query(base_query \\ base_query(), filters) do
    Enum.reduce(filters, base_query, fn
      {:latest_first, true}, query ->
        from(post in query, order_by: {:desc, post.created_at})

      {:id, id}, query ->
        from(post in query, where: post.id == ^id)

      {:slug, slug}, query ->
        from(post in query, where: post.slug == ^slug)

      {:limit, limit}, query ->
        from(post in query, limit: ^limit)

      _unsupported_filter, query ->
        query
    end)
  end
end
