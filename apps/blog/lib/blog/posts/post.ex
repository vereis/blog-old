defmodule Blog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "posts" do
    field :normalized_title, :string
    field :title, :string
    field :content, :string
    field :reading_time_minutes, :integer

    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime

    field :tags, {:array, :string}
  end

  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:id, :title, :content, :created_at, :updated_at, :tags])
    |> validate_required([:id, :title, :content, :created_at, :updated_at, :tags])
    |> unique_constraint(:id)
    |> put_normalized_title()
    |> put_estimated_reading_time(attrs)
  end

  defp put_normalized_title(%Ecto.Changeset{changes: %{title: title}} = changeset) do
    normalized_title =
      ~r/[^((A-Za-z0-9)| )]/
      |> Regex.replace(title, "", capture: :all)
      |> String.replace(" ", "_")
      |> String.downcase()

    changeset
    |> put_change(:normalized_title, normalized_title)
  end

  defp put_normalized_title(changeset), do: changeset

  defp put_estimated_reading_time(%Ecto.Changeset{} = changeset, %{"raw_content" => raw_content}) do
    put_estimated_reading_time(changeset, %{raw_content: raw_content})
  end

  # Most posts will be technical; so instead of 200wpm the average is supposedly
  # closer to half of what's expected
  @average_words_read_per_minute 100
  defp put_estimated_reading_time(%Ecto.Changeset{} = changeset, %{raw_content: raw_content}) do
    approximate_word_count =
      raw_content
      |> String.split(~r/\s/)
      |> Enum.count(fn string ->
        Regex.match?(~r/[a-zA-Z]+/, string)
      end)

    changeset
    |> put_change(
      :reading_time_minutes,
      ceil(approximate_word_count / @average_words_read_per_minute)
    )
  end

  defp put_estimated_reading_time(%Ecto.Changeset{} = changeset, _attrs), do: changeset
end
