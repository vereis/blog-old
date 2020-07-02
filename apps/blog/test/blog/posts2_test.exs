defmodule Blog.Posts2Test do
  use Blog.DataCase

  alias Blog.Posts2

  describe "posts" do
    alias Blog.Posts2.Post2

    @valid_attrs %{id: 42}
    @update_attrs %{id: 43}
    @invalid_attrs %{id: nil}

    def post2_fixture(attrs \\ %{}) do
      {:ok, post2} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts2.create_post2()

      post2
    end

    test "list_posts/0 returns all posts" do
      post2 = post2_fixture()
      assert Posts2.list_posts() == [post2]
    end

    test "get_post2!/1 returns the post2 with given id" do
      post2 = post2_fixture()
      assert Posts2.get_post2!(post2.id) == post2
    end

    test "create_post2/1 with valid data creates a post2" do
      assert {:ok, %Post2{} = post2} = Posts2.create_post2(@valid_attrs)
      assert post2.id == 42
    end

    test "create_post2/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts2.create_post2(@invalid_attrs)
    end

    test "update_post2/2 with valid data updates the post2" do
      post2 = post2_fixture()
      assert {:ok, %Post2{} = post2} = Posts2.update_post2(post2, @update_attrs)
      assert post2.id == 43
    end

    test "update_post2/2 with invalid data returns error changeset" do
      post2 = post2_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts2.update_post2(post2, @invalid_attrs)
      assert post2 == Posts2.get_post2!(post2.id)
    end

    test "delete_post2/1 deletes the post2" do
      post2 = post2_fixture()
      assert {:ok, %Post2{}} = Posts2.delete_post2(post2)
      assert_raise Ecto.NoResultsError, fn -> Posts2.get_post2!(post2.id) end
    end

    test "change_post2/1 returns a post2 changeset" do
      post2 = post2_fixture()
      assert %Ecto.Changeset{} = Posts2.change_post2(post2)
    end
  end
end
