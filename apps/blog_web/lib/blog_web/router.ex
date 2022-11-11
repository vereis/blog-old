defmodule BlogWeb.Router do
  use BlogWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {BlogWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", BlogWeb do
    pipe_through(:browser)

    live("/", RootLive, :home)
    live("/posts/", RootLive, :home)
    live("/posts/:slug", RootLive, :home)
    live("/posts_by_id/:id", RootLive, :home)

    get("/rss", RssController, :index)

    # coveralls-ignore-start
    live_dashboard("/dashboard", metrics: BlogWeb.Telemetry)
  end
end
