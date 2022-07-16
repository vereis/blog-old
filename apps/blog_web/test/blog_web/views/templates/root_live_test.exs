defmodule BlogWeb.Layouts.RootLiveTest do
  use BlogWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  alias Blog.Posts
  alias Blog.Posts.Post
  alias Blog.Repo

  @post_params %{
    id: 1,
    slug: "some-slug",
    title: "some-title",
    content: "some-content",
    markdown: "some-content",
    reading_time_minutes: 100,
    created_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now(),
    is_draft: false,
    tags: []
  }

  setup ctx do
    if ctx[:fixture] do
      for {fixture, index} <- Enum.with_index(ctx[:fixture], 1) do
        {:ok, _post} =
          @post_params
          |> Map.put(:id, index)
          |> Map.merge(fixture)
          |> Posts.create_post()
      end
    end

    :ok
  end

  describe "GET /" do
    test "raises if no posts exist", ctx do
      assert_raise UndefinedFunctionError, fn -> get(ctx.conn, "/") end
    end

    @tag fixture: [%{content: "About Me", title: "a"}, %{content: "Something Else", title: "b"}]
    test "renders the first post if multiple exists", ctx do
      assert html =
               ctx.conn
               |> get("/")
               |> html_response(200)

      assert html =~ "About Me"
    end

    @tag fixture: [%{content: "About Me", title: "a"}]
    test "renders sidebar, which contains various links", ctx do
      assert sidebar_links =
               ctx.conn
               |> live("/")
               |> then(fn {:ok, view, _html} -> view end)
               |> element("#sidebar#sidebar-links")
               |> render()

      for internal_link <- ["About", "Posts", "Resume", "RSS"] do
        assert sidebar_links =~ internal_link
      end

      for project_link <- [
            "https://github.com/vereis/ecto_hooks",
            "https://github.com/vetspire/sibyl"
          ] do
        assert sidebar_links =~ project_link
      end

      for external_link <- [
            "https://github.com/vereis",
            "https://twitter.com/yiiniiniin",
            "https://linkedin.com/in/yiiniiniin"
          ] do
        assert sidebar_links =~ external_link
      end
    end

    @tag fixture: [
           %{content: "About Me", title: "title", tags: ["uno", "dos", "tres"]},
           %{content: "Something Else", title: "another"}
         ]
    test "renders posts list, which contains links to any created blogposts", ctx do
      assert posts =
               ctx.conn
               |> live("/")
               |> then(fn {:ok, view, _html} -> view end)
               |> element("#posts-index")
               |> render()

      for post <- Repo.all(Post) do
        assert posts =~ post.title
        assert posts =~ to_string(post.reading_time_minutes) <> " min. read"

        for tag <- post.tags, tag = String.downcase(tag) do
          assert posts =~ tag
        end
      end
    end

    @tag fixture: [%{content: "About Me", title: "post title", tags: ["uno", "dos", "tres"]}]
    test "patches LV to the given post when clicked on the posts index", ctx do
      assert view =
               ctx.conn
               |> live("/")
               |> then(fn {:ok, view, _html} -> view end)

      assert view
             |> element("#posts-index div[phx-click=\"select-post\"]", "post title")
             |> render_click()

      assert_patched(view, "/posts/post_title")
    end

    @tag fixture: [%{content: "About Me", title: "post title", tags: ["uno", "dos", "tres"]}]
    test "patches LV to the about page when the logo is clicked", ctx do
      assert view =
               ctx.conn
               |> live("/")
               |> then(fn {:ok, view, _html} -> view end)

      assert view
             |> element("div[phx-click=\"select-about\"]")
             |> render_click()

      assert_patched(view, "/")
    end

    @tag fixture: [%{content: "About Me", title: "post title", tags: ["uno", "dos", "tres"]}]
    test "patches LV to the index page when the index button is clicked", ctx do
      assert view =
               ctx.conn
               |> live("/")
               |> then(fn {:ok, view, _html} -> view end)

      assert view
             |> element("div[phx-click=\"select-index\"]")
             |> render_click()

      assert_patched(view, "/posts")
    end
  end

  describe "GET /posts" do
    @tag fixture: [%{content: "About Me", title: "a"}, %{content: "Something Else", title: "b"}]
    test "is able to render", ctx do
      assert ctx.conn
             |> get("/posts")
             |> html_response(200)
    end
  end

  describe "GET /posts/:slug" do
    @tag fixture: [%{content: "About Me", slug: "some_slug", title: "some slug"}]
    test "is able to render", ctx do
      assert ctx.conn
             |> get("/posts/some_slug")
             |> html_response(200)
    end
  end
end
