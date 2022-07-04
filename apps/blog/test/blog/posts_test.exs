defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts
  alias Blog.Posts.Post

  describe "create_post/2" do
    @valid_attrs %{
      "id" => 1,
      "title" => "Test",
      "markdown" => "Some Content",
      "content" => "<p>Some Content</p>",
      "created_at" => "2021-08-13T00:18:47Z",
      "updated_at" => "2021-08-13T00:18:47Z",
      "tags" => []
    }

    test "returns changeset error when given invalid attrs" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(%{})
    end

    test "inserts post given valid attrs" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)

      assert post.slug == "test"
      assert post.title == "Test"
      assert post.content == "<p>Some Content</p>"
      assert post.markdown == "Some Content"
      assert post.created_at == ~U[2021-08-13 00:18:47.000000Z]
      assert post.updated_at == ~U[2021-08-13 00:18:47.000000Z]

      refute post.is_draft
      assert post.tags == []
      assert post.reading_time_minutes == 1
    end

    test "upserts post given attrs of a post that has already been created" do
      assert {:ok, %Post{markdown: "Some Content"}} = Posts.create_post(@valid_attrs)

      assert {:ok, %Post{markdown: "Updated"}} =
               Posts.create_post(%{@valid_attrs | "markdown" => "Updated"})

      assert Repo.aggregate(Post, :count) == 1
    end
  end
end
