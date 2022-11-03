defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts
  alias Blog.Posts.Post

  @valid_attrs %{
    "id" => 1,
    "title" => "Test",
    "markdown" => "Some Content",
    "content" => "<p>Some Content</p>",
    "created_at" => "2021-08-13T00:18:47Z",
    "updated_at" => "2021-08-13T00:18:47Z",
    "tags" => []
  }
  describe "create_post/2" do
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

  describe "get_post/1" do
    test "given understood arguments, returns result" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert {:ok, ^post} = Posts.get_post(id: post.id)
    end
  end

  describe "list_posts/1" do
    test "returns empty list if no posts" do
      assert {:ok, []} = Posts.list_posts()
    end

    test "returns empty list if given invalid search criteria" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert {:ok, []} = Posts.list_posts(slug: "something_random")
    end

    test "returns posts if given invalid search criteria" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert {:ok, [^post]} = Posts.list_posts(slug: "test")
    end

    test "ignores invalid filters" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert {:ok, [^post]} = Posts.list_posts(something_random: "123")
    end

    test "returns posts, most recent first, when sort filter given" do
      assert {:ok, %Post{} = post_1} =
               Posts.create_post(%{
                 @valid_attrs
                 | "id" => 1,
                   "created_at" => "2022-05-01T00:00:00Z"
               })

      assert {:ok, %Post{} = post_2} =
               Posts.create_post(%{
                 @valid_attrs
                 | "id" => 2,
                   "title" => "another",
                   "created_at" => "2022-01-01T00:00:00Z"
               })

      assert {:ok, [^post_1, ^post_2]} = Posts.list_posts(latest_first: true)
    end
  end

  describe "get_post!/1" do
    test "given understood arguments, returns result" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert ^post = Posts.get_post!(id: post.id)
    end
  end

  describe "list_posts!/1" do
    test "returns empty list if no posts" do
      assert [] = Posts.list_posts!()
    end

    test "returns empty list if given invalid search criteria" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert [] = Posts.list_posts!(slug: "something_random")
    end

    test "returns posts if given invalid search criteria" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert [^post] = Posts.list_posts!(slug: "test")
    end

    test "ignores invalid filters" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert [^post] = Posts.list_posts!(something_random: "123")
    end

    test "returns posts, most recent first, when sort filter given" do
      assert {:ok, %Post{} = post_1} =
               Posts.create_post(%{
                 @valid_attrs
                 | "id" => 1,
                   "created_at" => "2022-05-01T00:00:00Z"
               })

      assert {:ok, %Post{} = post_2} =
               Posts.create_post(%{
                 @valid_attrs
                 | "id" => 2,
                   "title" => "another",
                   "created_at" => "2022-01-01T00:00:00Z"
               })

      assert [^post_1, ^post_2] = Posts.list_posts!(latest_first: true)
    end
  end
end
