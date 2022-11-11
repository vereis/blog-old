defmodule BlogWeb.RootLive do
  @moduledoc """
  Root layout which gets rendered as a liveview and sets up sidebar / blog content
  views.
  """

  use BlogWeb, :live_view

  alias Blog.Posts.Post
  alias Blog.Repo

  alias BlogWeb.Components.Nav
  alias BlogWeb.Components.Posts

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    post_id = params |> Map.get("id", "1") |> String.to_integer()

    socket =
      socket
      |> assign_new(:posts, fn -> Blog.Posts.list_posts!(latest_first: true) end)
      |> assign_new(:post, fn -> Blog.Posts.get_post!(id: post_id) end)
      |> assign_new(:state, fn -> :about end)
      |> assign_new(:uri, fn -> "" end)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.root state={@state} >
      <Nav.sidebar state={@state} />
      <!--<Nav.bar state={@state} title={@post.title} />-->
      <Nav.main>
        <Posts.index posts={@posts} state={@state} uri={@uri} />
        <Posts.content post={@post} state={@state} />
      </Nav.main>
    </.root>
    """
  end

  def root(assigns) do
    ~H"""
    <div id="root" class="flex flex-col max-h-full h-full 2xl:flex-row">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def handle_event("select-post", %{"post-slug" => post_slug}, socket) do
    {:noreply, push_patch(socket, to: "/posts/" <> post_slug)}
  end

  def handle_event("select-index", _params, socket) do
    {:noreply, push_patch(socket, to: "/posts")}
  end

  def handle_event("select-about", _params, socket) do
    {:noreply, push_patch(socket, to: "/")}
  end

  @impl Phoenix.LiveView
  def handle_params(%{"slug" => post_slug}, uri, socket) do
    socket =
      socket
      |> assign(:state, state_of(uri))
      |> assign(:post, Blog.Posts.get_post!(slug: post_slug))
      |> assign(:uri, uri)

    {:noreply, socket}
  end

  def handle_params(_params, uri, socket) do
    state = state_of(uri)

    socket =
      socket
      |> assign(:state, state)
      |> then(fn socket ->
        (state == :about && assign(socket, :post, Repo.get(Post, 1))) || socket
      end)

    {:noreply, socket}
  end

  defp state_of(uri) do
    case URI.parse(uri) do
      %URI{path: "/posts/" <> rest} when byte_size(rest) > 0 ->
        :post

      %URI{path: "/posts" <> _rest} ->
        :index

      %URI{path: "/"} ->
        :about
    end
  end
end
