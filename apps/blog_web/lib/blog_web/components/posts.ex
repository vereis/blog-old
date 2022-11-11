defmodule BlogWeb.Components.Posts do
  @moduledoc false

  use Phoenix.Component

  alias BlogWeb.Components.Nav
  alias Phoenix.LiveView.JS

  def select_post(js \\ %JS{}) do
    js
    |> JS.dispatch("reset-scroll")
    |> JS.push("select-post")
  end

  def index(assigns) do
    ~H"""
    <main id="posts-index" class={"
      #{if @state in [:about, :post], do: "brightness-50"}
      absolute
      bg-white
      duration-300
      ease-in-out
      h-full
      max-h-full
      md:border-r
      md:brightness-100
      md:relative
      md:transition-none
      md:w-128
      overflow-y-scroll
      transform-gpu
      transition
      w-full
    "}>
      <.title>
        <Nav.action_left state={:posts} class="2xl:invisible"/>
        <p class="font-bold md:font-normal">All Posts</p>
        <Nav.action_right state={@state} class="invisible"/>
      </.title>
      <div class="
        sm:w-128
        md:w-auto
        w-full
        mx-auto
      ">
        <%= for post <- @posts, not post.is_draft do %>
          <.post post={post} uri={@uri} state={@state} />
        <% end %>
      </div>
    </main>
    """
  end

  def title(assigns) do
    ~H"""
    <nav class={"
      #{assigns[:class]}
      bg-white/80
      duration-300
      ease-in-out
      border-b
      p-4
      sticky
      top-0
      backdrop-blur-md
      transform-gpu
      transition
      w-full
      z-40
      flex
    "}>
      <div class="
        2xl:h-10
        flex
        flex-grow
        items-center
        justify-between
        my-1
        space-x-4
      ">
        <%= render_slot(@inner_block) %>
      </div>
    </nav>
    """
  end

  def post(assigns) do
    ~H"""
    <div phx-click={select_post()} phx-value-post-slug={@post.slug} class={"
      block
      cursor-pointer
      hover:bg-gray-300/20
      md:border-b
      md:px-5
      md:py-5
      px-4
      py-4
      select-none
    "}>
      <div class="
        flex
        flex-col
        space-y-1
      ">
        <a href="#" class="
          text-blue-900
          underline
          underline-offset-4
          text-sm
          mb-1.5
        ">
          <%= @post.title %>
        </a>
        <div class="
          flex
          space-x-2
          text-xs
          oblique
        ">
          <.metadata icon="book-open" value={Calendar.strftime(@post.created_at, "%b %d, %Y")}/>
          <.metadata icon="clock" value={Enum.join([@post.reading_time_minutes, "min. read"], " ")}/>
        </div>
        <div class="
          flex
          flex-wrap
          gap-x-2
          gap-y-1
          text-xs
        ">
          <%= for tag <- @post.tags do %> <.tag tag={tag} /> <% end %>
        </div>
      </div>
    </div>
    """
  end

  def metadata(assigns) do
    ~H"""
    <div class="
      flex
      items-center
      space-x-1
    ">
      <span><%= @value %></span>
    </div>
    """
  end

  def tag(assigns) do
    ~H"""
    <div class="
      before:-mr-1
      before:content-['#']
      lowercase
      whitespace-nowrap
      text-gray-600
      text-xs
    ">
      <%= @tag %>
    </div>
    """
  end

  def content(assigns) do
    ~H"""
      <article id="content" class={"
        #{if @state not in [:about, :post], do: "translate-x-full"}
        absolute
        bg-white
        duration-300
        ease-in-out
        h-full
        max-h-full
        max-w-none
        md:relative
        md:transition-none
        md:translate-x-0
        overflow-y-scroll
        transform-gpu
        transition-transform
        w-full
      "}>
      <.title class="2xl:hidden justify-between">
        <Nav.action_left state={:post} class="md:invisible"/>
        <p class="font-bold line-clamp-1"><%= @post.title %></p>
        <Nav.action_right state={@state} class="invisible"/>
      </.title>
      <div class="
        2xl:pb-36
        2xl:prose-h1:text-4xl
        2xl:prose-h2:text-3xl
        2xl:prose-h3:text-2xl
        2xl:prose-h4:text-xl
        2xl:pt-36
        hover:prose-a:text-rose-400
        leading-loose
        lg:py-16
        md:pb-5
        md:pt-5
        mx-auto
        pt-4
        pb-12
        prose
        prose-sm
        prose-a:text-blue-900
        prose-a:underline
        prose-a:underline-offset-4
        prose-a:font-normal
        prose-code:after:content-none
        prose-code:before:content-none
        prose-h1:font-bold
        prose-h1:mb-8
        prose-h1:text-2xl
        prose-h2:font-bold
        prose-h2:mb-4
        prose-h2:text-xl
        prose-h3:font-bold
        prose-h3:mb-4
        prose-h3:text-lg
        prose-h4:mb-4
        prose-neutral
        prose-pre:overflow-x-auto
        prose-pre:bg-black/90
        sm:py-12
        pb-4
        px-4
        lg:prose-h1:text-3xl
        lg:prose-h1:mb-4
        lg:prose-h2:text-2xl
        lg:prose-h3:text-xl
        lg:prose-base
      ">
        <%= {:safe, @post.content } %>
      </div>
    </article>
    """
  end
end
