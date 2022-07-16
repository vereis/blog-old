defmodule BlogWeb.Components.Posts do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias Heroicons.LiveView, as: Heroicons

  def index(assigns) do
    ~H"""
    <main class={"
      #{if @state in [:about, :post], do: "brightness-50"}
      transition transform-gpu ease-in-out duration-300 h-full
      absolute pt-10 bg-white min-w-full max-h-full overflow-y-scroll
    "}>
      <div class="max-w-prose mx-auto">
        <%= for post <- @posts, not post.is_draft do %>
          <.post post={post} />
        <% end %>
      </div>
    </main>
    """
  end

  def post(assigns) do
    ~H"""
    <div phx-click="select-post" phx-value-post-slug={@post.slug} class="block py-6 px-10">
      <div class="font-semibold underline decoration-wavy decoration-rose-400 underline-offset-2">
        <%= @post.title %>
      </div>
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
      <article class={"
        #{if @state not in [:about, :post], do: "translate-x-full"}
        absolute transform-gpu transition-transform ease-in-out duration-300
        h-full max-h-full bg-white w-full max-w-none overflow-y-scroll
      "}>
      <div class="
        mx-auto
        prose pt-10 py-8 px-10 prose prose-neutral
        prose-h1:text-2xl prose-h1:font-bold
        prose-h2:text-xl  prose-h2:font-bold
        prose-h3:text-lg  prose-h3:font-bold
        prose-pre:overflow-x-auto
        prose-code:before:content-none prose-code:after:content-none prose-code:font-semibold
        prose-a:underline prose-a:decoration-wavy prose-a:decoration-rose-400 prose-a:underline-offset-2
        prose-a:font-semibold
      ">
        <%= {:safe, @post.content } %>
      </div>
    </article>
    """
  end
end
