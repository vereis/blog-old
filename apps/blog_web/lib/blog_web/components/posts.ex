defmodule BlogWeb.Components.Posts do
  @moduledoc false

  use Phoenix.Component

  alias Heroicons.LiveView, as: Heroicons
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
      transition transform-gpu ease-in-out duration-300 h-full
      absolute pt-10 bg-white w-full max-h-full overflow-y-scroll
      md:relative md:w-128 md:brightness-100 md:pt-0 md:border-r md:transition-none
    "}>
      <div class="max-w-prose mx-auto">
        <%= for post <- @posts, not post.is_draft do %>
          <.post post={post} uri={@uri} state={@state} />
        <% end %>
      </div>
    </main>
    """
  end

  def post(assigns) do
    ~H"""
    <div phx-click={select_post()} phx-value-post-slug={@post.slug} class={"
      cursor-pointer select-none
      block py-6 px-10 md:py-5 md:px-5 md:border-b hover:bg-gray-100/50
    "}>
      <a href="#" class="font-semibold">
        <%= @post.title %>
      </a>
      <div class="flex space-x-2 mt-2">
        <.metadata icon="book-open" value={Calendar.strftime(@post.created_at, "%b %d, %Y")}/>
        <.metadata icon="clock" value={Enum.join([@post.reading_time_minutes, "min. read"], " ")}/>
      </div>
      <div class="flex flex-wrap mt-2.5 gap-x-2 gap-y-1">
        <%= for tag <- @post.tags do %> <.tag tag={tag} /> <% end %>
      </div>
    </div>
    """
  end

  def metadata(assigns) do
    ~H"""
    <div class="flex items-center space-x-1 text-sm">
      <Heroicons.icon name={@icon} type="outline" class="h-4 w-4" />
      <span><%= @value %></span>
    </div>
    """
  end

  def tag(assigns) do
    ~H"""
    <div class="whitespace-nowrap lowercase font-mono before:content-['#'] before:-mr-1.5 text-xs">
      <%= @tag %>
    </div>
    """
  end

  def content(assigns) do
    ~H"""
      <article id="content" class={"
        #{if @state not in [:about, :post], do: "translate-x-full"}
        absolute transform-gpu transition-transform ease-in-out duration-300
        h-full max-h-full bg-white w-full max-w-none overflow-y-scroll
        md:relative md:translate-x-0 md:transition-none
      "}>
      <div class="
        mx-auto
        pt-12 pb-12 px-10 prose prose-neutral text-lg
        prose-h1:text-3xl prose-h1:font-bold
        prose-h2:text-2xl prose-h2:font-bold
        prose-h3:text-xl prose-h3:font-bold
        prose-h1:font-serif
        prose-h2:font-serif
        prose-h3:font-serif
        prose-h4:font-serif
        prose-h1:mb-12
        prose-h2:mb-6
        prose-h3:mb-6
        prose-h4:mb-6
        prose-pre:overflow-x-auto prose-pre:text-sm
        prose-code:before:content-none prose-code:after:content-none
        hover:prose-a:text-rose-400 prose-a:font-semibold prose-a:underline prose-a:underline-offset-4 prose-a:underline-thickness-2
        md:pt-18 md:pb-18 lg:pt-28 lg:pb-28 2xl:pt-36 2xl:pb-36
        2xl:max-w-3xl
        2xl:prose-h1:text-4xl prose-h1:font-bold
        2xl:prose-h2:text-3xl prose-h2:font-bold
        2xl:prose-h3:text-2xl prose-h3:font-bold
      ">
        <%= {:safe, @post.content } %>
      </div>
    </article>
    """
  end
end
