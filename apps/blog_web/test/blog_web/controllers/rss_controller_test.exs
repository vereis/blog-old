defmodule BlogWeb.Controllers.RssControllerTest do
  use BlogWeb.ConnCase, async: true

  alias Blog.Posts

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

  describe "GET /rss" do
    test "returns valid XML boilerplate", ctx do
      assert xml =
               ctx.conn
               |> get("/rss")
               |> response(200)

      assert xml =~ ~s'<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">'
      assert xml =~ ~s"<title>Chris Bailey's blog</title>"
      assert xml =~ ~s'type="application/rss+xml"'
    end

    @tag fixture: [%{content: "About Me", title: "Random Title"}]
    test "posts will be contained in XML response", ctx do
      assert xml =
               ctx.conn
               |> get("/rss")
               |> response(200)

      assert xml =~ ~s'<title>Random Title</title>'
      assert xml =~ ~s'<link>/posts/random_title</link>'
    end
  end
end
