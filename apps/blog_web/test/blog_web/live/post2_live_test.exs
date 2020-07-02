defmodule BlogWeb.Post2LiveTest do
  use BlogWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Blog.Posts2

  @create_attrs %{id: 42}
  @update_attrs %{id: 43}
  @invalid_attrs %{id: nil}

  defp fixture(:post2) do
    {:ok, post2} = Posts2.create_post2(@create_attrs)
    post2
  end

  defp create_post2(_) do
    post2 = fixture(:post2)
    %{post2: post2}
  end

  describe "Index" do
    setup [:create_post2]

    test "lists all posts", %{conn: conn, post2: post2} do
      {:ok, _index_live, html} = live(conn, Routes.post2_index_path(conn, :index))

      assert html =~ "Listing Posts"
    end

    test "saves new post2", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.post2_index_path(conn, :index))

      assert index_live |> element("a", "New Post2") |> render_click() =~
        "New Post2"

      assert_patch(index_live, Routes.post2_index_path(conn, :new))

      assert index_live
             |> form("#post2-form", post2: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#post2-form", post2: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post2_index_path(conn, :index))

      assert html =~ "Post2 created successfully"
    end

    test "updates post2 in listing", %{conn: conn, post2: post2} do
      {:ok, index_live, _html} = live(conn, Routes.post2_index_path(conn, :index))

      assert index_live |> element("#post2-#{post2.id} a", "Edit") |> render_click() =~
        "Edit Post2"

      assert_patch(index_live, Routes.post2_index_path(conn, :edit, post2))

      assert index_live
             |> form("#post2-form", post2: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#post2-form", post2: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post2_index_path(conn, :index))

      assert html =~ "Post2 updated successfully"
    end

    test "deletes post2 in listing", %{conn: conn, post2: post2} do
      {:ok, index_live, _html} = live(conn, Routes.post2_index_path(conn, :index))

      assert index_live |> element("#post2-#{post2.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#post2-#{post2.id}")
    end
  end

  describe "Show" do
    setup [:create_post2]

    test "displays post2", %{conn: conn, post2: post2} do
      {:ok, _show_live, html} = live(conn, Routes.post2_show_path(conn, :show, post2))

      assert html =~ "Show Post2"
    end

    test "updates post2 within modal", %{conn: conn, post2: post2} do
      {:ok, show_live, _html} = live(conn, Routes.post2_show_path(conn, :show, post2))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Post2"

      assert_patch(show_live, Routes.post2_show_path(conn, :edit, post2))

      assert show_live
             |> form("#post2-form", post2: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#post2-form", post2: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post2_show_path(conn, :show, post2))

      assert html =~ "Post2 updated successfully"
    end
  end
end
