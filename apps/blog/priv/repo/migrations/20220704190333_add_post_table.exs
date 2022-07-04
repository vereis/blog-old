defmodule Blog.Repo.Migrations.AddPostTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:slug, :string)
      add(:title, :string)

      add(:content, :text)
      add(:markdown, :text)

      add(:reading_time_minutes, :integer)

      add(:created_at, :utc_datetime_usec)
      add(:updated_at, :utc_datetime_usec)

      add(:is_draft, :boolean)
      add(:tags, {:array, :string})
    end

    create(unique_index(:posts, [:slug]))
  end
end
